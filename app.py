import streamlit as st
from streamlit_ace import st_ace
import julia

julia.install()  

from julia import Main

Main.include("main.jl")

Main.main()

st.set_page_config(page_title="RISC-V Simulator", layout="wide")
st.title("RISC-V Simulator")

# Define the width and height for the code areas
code_width = 800
code_height = 600

# Define the font size for the user input code
size = 20

# Define custom CSS to increase font size
custom_css = f"""
<style>
    .ace_editor.ace-tm {{
        font-size: {size}px !important;
    }}
</style>
"""

# Inject the custom CSS
st.markdown(custom_css, unsafe_allow_html=True)

col1, col2 = st.columns(2)

input1=""
input2=""

with col1:
    st.markdown("## Core-1 Input")
    code1 = st_ace(value=input1,language='assembly_x86', theme='tomorrow_night', key="core1", height=code_height,font_size=size)
    initial_text = st.text_area("Output for Core-1",
                                value="Output-1",
                                height=50,
                                label_visibility="hidden")

    

with col2:
    st.markdown("## Core-2 Input")
    code2 = st_ace(value=input2, language='assembly_x86', theme='tomorrow_night', key="core2", height=code_height,font_size=size)
    initial_text = st.text_area("Output for Core-2",
                                value="Output-2",
                                height=50,
                                label_visibility="hidden")
print(type(code2))
print(code1)