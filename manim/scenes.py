from manimlib import *
import numpy as np

class RiskAndCompounding(Scene):
    def construct(self):
        # 3Blue1Brown-style explanatory scene: risk, distribution, compounding.
        title = Text("RISK IS A SYSTEM", font_size=52, color=WHITE)
        title.to_edge(UP, buff=0.55)
        underline = Line(LEFT*5.4, RIGHT*5.4, color=TEAL, stroke_width=3).next_to(title, DOWN, buff=0.18)
        self.play(FadeIn(title, shift=DOWN*0.25), ShowCreation(underline), run_time=1.1)
        axes = Axes((-4,4,1), (0,5,1), width=8, height=3.4, axis_config={"stroke_color": GREY_B, "stroke_width": 2})
        axes.shift(DOWN*0.6)
        curve = axes.get_graph(lambda x: 2.6*np.exp(-x*x/1.4), color=BLUE, stroke_width=5)
        center = DashedLine(axes.c2p(0,0), axes.c2p(0,3.4), color=YELLOW)
        label = Text("Probability distribution", font_size=30, color=BLUE).next_to(axes, UP, buff=0.22)
        self.play(ShowCreation(axes), FadeIn(label), run_time=0.8)
        self.play(ShowCreation(curve), ShowCreation(center), run_time=1.5)
        # highlight tail risk
        tail = axes.get_graph(lambda x: 2.6*np.exp(-x*x/1.4), x_range=(2.1,4), color=RED, stroke_width=7)
        risk_label = Text("TAIL RISK", font_size=28, color=RED).move_to(axes.c2p(2.7,1.4))
        self.play(ShowCreation(tail), FadeIn(risk_label), run_time=0.8)
        self.wait(0.5)
        self.play(FadeOut(axes), FadeOut(curve), FadeOut(center), FadeOut(tail), FadeOut(label), FadeOut(risk_label), run_time=0.5)
        # Compounding bars
        subtitle=Text("CONSISTENCY COMPOUNDS",font_size=42,color=TEAL).next_to(title,DOWN,buff=0.45)
        self.play(FadeIn(subtitle))
        bars=VGroup(); values=[1.0,1.12,1.25,1.4,1.57,1.76,1.98,2.22,2.5,2.8,3.15,3.55]
        for i,v in enumerate(values):
            b=Rectangle(width=.42,height=v*.65,fill_color=BLUE_E,fill_opacity=.85,stroke_color=TEAL,stroke_width=1)
            b.move_to(np.array([-5.0+i*.85,-2.0+v*.325,0]))
            bars.add(b)
        baseline=Line(LEFT*5.5+DOWN*2,RIGHT*5.5+DOWN*2,color=GREY_B)
        self.play(ShowCreation(baseline))
        self.play(LaggedStart(*[GrowFromEdge(b,DOWN) for b in bars],lag_ratio=.08),run_time=2.4)
        final=Text("Protect the downside. Let time work.",font_size=34,color=WHITE).to_edge(DOWN,buff=.35)
        self.play(FadeIn(final,shift=UP*.2),run_time=.6)
        self.wait(1)


class LeverageSurface(ThreeDScene):
    def construct(self):
        heading = Text("LEVERAGE / EXPOSURE SURFACE", font_size=36, color=TEAL)
        heading.to_edge(UP, buff=0.3)
        self.add_fixed_in_frame_mobjects(heading)
        self.set_camera_orientation(phi=68 * DEG, theta=-48 * DEG, distance=9)
        axes = ThreeDAxes(
            x_range=(-3, 3, 1), y_range=(-3, 3, 1), z_range=(-2, 4, 1),
            width=7, height=6, depth=5,
            axis_config={"stroke_color": GREY_B, "stroke_width": 1.5},
        )
        surface = ParametricSurface(
            lambda u, v: axes.c2p(u, v, 0.32 * u * u - 0.38 * v * v),
            u_range=(-2.4, 2.4), v_range=(-2.4, 2.4), resolution=(18, 18),
            color=BLUE, opacity=0.72,
        )
        self.play(ShowCreation(axes), run_time=1.1)
        self.play(ShowCreation(surface), run_time=2.0)
        self.begin_ambient_camera_rotation(rate=0.10)
        self.wait(3.5)
        self.stop_ambient_camera_rotation()
        caption = Text("AMPLIFICATION / NON-LINEAR RISK", font_size=26, color=YELLOW)
        caption.to_edge(DOWN, buff=0.35)
        self.add_fixed_in_frame_mobjects(caption)
        self.play(FadeIn(caption), run_time=0.5)
        self.wait(1.0)
