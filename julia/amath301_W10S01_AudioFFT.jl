### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ ea5ee41c-6063-11eb-2552-5fac8ae8dcbd
## Fast Fourier Transform Audio
#

begin
	using Plots
	using FFTW
	using SampledSignals
end

# ╔═╡ 9cbf2ea2-6085-11eb-20e5-77ec18d68d6f
md"The html entry will start capturing the microphone into ``audio`` until the button is pressed.  Expand the cell and re-run it to start again."

# ╔═╡ 36c6849a-6064-11eb-023c-4f0bb7078696
@bind audio HTML("""
<audio id="player"></audio>
<button class="button" id="stopButton">Stop</button>
<script>
  const player = document.getElementById('player');
  const stop = document.getElementById('stopButton');
  const handleSuccess = function(stream) {
    const context = new AudioContext({ sampleRate: 44100 });
    const analyser = context.createAnalyser();
    const source = context.createMediaStreamSource(stream);
    source.connect(analyser);
    
    const bufferLength = analyser.frequencyBinCount;
    
    let dataArray = new Float32Array(bufferLength);
    let animFrame;
    
    const streamAudio = () => {
      animFrame = requestAnimationFrame(streamAudio);
      analyser.getFloatTimeDomainData(dataArray);
      player.value = dataArray;
      player.dispatchEvent(new CustomEvent("input"));
    }
    streamAudio();
    stop.onclick = e => {
      source.disconnect(analyser);
      cancelAnimationFrame(animFrame);
    }
  }
  navigator.mediaDevices.getUserMedia({ audio: true, video: false })
    .then(handleSuccess)
</script>
<style>
.button {
  background-color: darkred;
  border: none;
  border-radius: 12px;
  color: white;
  padding: 15px 32px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 16px;
  font-family: "Alegreya Sans", sans-serif;
  margin: 4px 2px;
  cursor: pointer;
}
</style>
""")

# ╔═╡ 367eb53e-6064-11eb-21f3-694712e6582c
begin
	Tₐ= domain(SampleBuf(Array(audio), 44100))
	plot(Tₐ, SampleBuf(Array(audio), 44100),
		legend=false, ylims=(-1,1), size=(600,120))
end

# ╔═╡ 361cdd32-6064-11eb-2425-2d6a60c37d77
let
	freq= fft( SampleBuf( Array(audio), 44100) )
	power= abs.( freq ) / length( freq)
	n= length( power) ÷ 5
	Fₐ= range(0, 44100, length=n)
	plot( Fₐ[4:n], power[4:n],
		title="Spectrum", leg=false,		
		xaxis= :log10, yaxis=:log10,
		ylims=(0.002,0.5), size=(600, 200) )
end

# ╔═╡ Cell order:
# ╠═ea5ee41c-6063-11eb-2552-5fac8ae8dcbd
# ╟─9cbf2ea2-6085-11eb-20e5-77ec18d68d6f
# ╟─36c6849a-6064-11eb-023c-4f0bb7078696
# ╠═367eb53e-6064-11eb-21f3-694712e6582c
# ╠═361cdd32-6064-11eb-2425-2d6a60c37d77
