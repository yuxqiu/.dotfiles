{
  flake.modules.homeManager.llama =
    { config, pkgs, ... }:
    {
      # Use vulkan on Linux
      #
      # Model can be downloaded and ran by following the guide from
      # https://unsloth.ai/docs.
      home.packages = with pkgs; [
        llama-cpp-vulkan

        # Here, we configure qwen3.5-4B as it is the best local
        # model that can be ran on my machine.
        #
        # In the future, when this becomes complex, we can encapsulate
        # the following into configs to selectively enable models.
        (pkgs.writeShellApplication {
          name = "llama-qwen-server";
          runtimeInputs = [ pkgs.llama-cpp-vulkan ];
          text = ''
            export LLAMA_CACHE="${config.home.homeDirectory}/.cache/llama.cpp/unsloth/Qwen3.5-4B-GGUF"
            llama-server \
              -hf unsloth/Qwen3.5-4B-GGUF:UD-Q4_K_XL \
              --ctx-size 16384 \
              --temp 0.6 \
              --top-p 0.95 \
              --top-k 20 \
              --min-p 0.00 \
              --alias "unsloth/Qwen3.5-4B-GGUF" \
              --port 8001 \
              --chat-template-kwargs '{"enable_thinking":true}'
          '';
        })
      ];
    };
}
