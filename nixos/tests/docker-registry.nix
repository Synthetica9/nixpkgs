# This test runs docker-registry and check if it works

import ./make-test.nix ({ pkgs, ...} : {
  name = "docker-registry";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ globin ma27 ];
  };

  nodes = {
    registry = { config, pkgs, ... }: {
      services.dockerRegistry.enable = true;
      services.dockerRegistry.enableDelete = true;
      services.dockerRegistry.port = 8080;
      services.dockerRegistry.listenAddress = "0.0.0.0";
      networking.firewall.allowedTCPPorts = [ 8080 ];
    };

    client1 = { config, pkgs, ...}: {
      virtualisation.docker.enable = true;
      virtualisation.docker.extraOptions = "--insecure-registry registry:8080";
    };

    client2 = { config, pkgs, ...}: {
      virtualisation.docker.enable = true;
      virtualisation.docker.extraOptions = "--insecure-registry registry:8080";
      environment.systemPackages = [ pkgs.jq ];
    };
  };

  testScript = ''
    $client1->start();
    $client1->waitForUnit("docker.service");
    $client1->succeed("tar cv --files-from /dev/null | docker import - scratch");
    $client1->succeed("docker tag scratch registry:8080/scratch");

    $registry->start();
    $registry->waitForUnit("docker-registry.service");
    $client1->succeed("docker push registry:8080/scratch");

    $client2->start();
    $client2->waitForUnit("docker.service");
    $client2->succeed("docker pull registry:8080/scratch");
    $client2->succeed("docker images | grep scratch");

    $client2->succeed(
      'curl -fsS -X DELETE registry:8080/v2/scratch/manifests/$(curl registry:8080/v2/scratch/manifests/latest | jq ".fsLayers[0].blobSum" | sed -e \'s/"//g\')'
    );
  '';
})
