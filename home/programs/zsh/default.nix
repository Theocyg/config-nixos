{ config, pkgs, ... }:

{
    programs.zsh = {
      enable = true;
            oh-my-zsh = {
                enable = true;
                theme = "agnoster";
                plugins = [
                    "git"
                ];
            };
            autosuggestion.enable = true;
            enableCompletion = true;
            syntaxHighlighting.enable = true;
             initExtra = ''
      function start_ssh_agent {
        eval "$(ssh-agent -s)" > /dev/null 2>&1
        ssh-add /home/kaan/.ssh/id_home > /dev/null 2>&1
      }

      start_ssh_agent
      export NIXOS_OZONE_WL=1
  '';
        };
}
