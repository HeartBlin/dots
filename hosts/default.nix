{
  inputs,
  nixpkgs,
  ...
}: let
  username = "heartblin";
  sharedArgs = {inherit inputs username;};

  hm = inputs.homeManager.nixosModules.home-manager;

  modulePath = ../modules;
  homePath = ../homes;

  coreModules = modulePath + /core;
  securityModules = modulePath + /security;
  systemModules = modulePath + /system;

  common = coreModules;
  security = securityModules;
  system = systemModules;

  homes = [hm homePath];

  shared = [
    common
    security
    system
  ];
in {
  /*
  ROG Strix G513
  */
  Mainz = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "Mainz";}
        ./Mainz
      ]
      ++ builtins.concatLists [shared homes];

    specialArgs = sharedArgs;
  };

  /*
  TODO - others
  */
}

