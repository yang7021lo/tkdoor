import matplotlib.pyplot as plt

# 데이터 정의
wide = 2780
high = 2500
wide_fixglass = 1305
high_fixglass = 2160
autofixhabar = 1313
wide_doorglass = 1279
high_doorglass = 2135
opensize = 1312
doorhigh = 2270
floor = "mm 뭍힘"

# 그림 생성
def draw_diagram():
    fig, ax = plt.subplots(figsize=(8, 6))

    # Outer dimensions
    ax.plot([0, wide], [high, high], 'k-', lw=2)  # Top line
    ax.plot([0, 0], [0, high], 'k-', lw=2)       # Left line
    ax.plot([wide, wide], [0, high], 'k-', lw=2) # Right line
    ax.plot([0, wide], [0, 0], 'k-', lw=2)       # Bottom line

    # Inner divisions (fixed glass and door glass)
    ax.plot([wide_fixglass, wide_fixglass], [0, high_fixglass], 'k--', lw=1)
    ax.plot([0, wide_fixglass], [high_fixglass, high_fixglass], 'k--', lw=1)
    ax.text(wide_fixglass / 2, high_fixglass / 2, f"좌 픽스 유리\n{wide_fixglass} X {high_fixglass}", ha='center', va='center', fontsize=10)

    # Door glass in the middle
    ax.plot([wide_fixglass, wide_fixglass + wide_doorglass], [high_doorglass, high_doorglass], 'k--', lw=1)
    ax.text(wide_fixglass + wide_doorglass / 2, high_doorglass / 2, f"도어 유리치수\n{wide_doorglass} X {high_doorglass}", ha='center', va='center', fontsize=10)

    # Open size
    ax.text(wide_fixglass + wide_doorglass / 2, -100, f"오픈 사이즈\n{opensize}", ha='center', va='center', fontsize=10, color='yellow', bbox=dict(facecolor='black', edgecolor='none'))

    # Floor size below
    ax.text(wide_fixglass / 2, -200, f"걸레받이 치수\n{autofixhabar}", ha='center', va='center', fontsize=10)

    # Add labels for outer dimensions
    ax.text(wide / 2, high + 100, f"가로외경: {wide} mm", ha='center', fontsize=12, weight='bold')
    ax.text(-100, high / 2, f"세로외경\n{high} mm", ha='center', fontsize=12, weight='bold', rotation=90)

    # Set axis limits and remove ticks
    ax.set_xlim(-200, wide + 200)
    ax.set_ylim(-500, high + 500)
    ax.axis('off')

    # Save the diagram
    plt.savefig("door_diagram.png", bbox_inches='tight', dpi=300)
    plt.close()

# Generate the diagram
draw_diagram()

# HTML 생성
html_content = f"""
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>도어 데이터</title>
    <style>
        body {{
            font-family: Arial, sans-serif;
            text-align: center;
        }}
        .container {{
            width: 80%;
            margin: auto;
        }}
        table {{
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
        }}
        th, td {{
            border: 1px solid #000;
            padding: 10px;
            text-align: center;
        }}
        .highlight {{
            background-color: yellow;
            font-weight: bold;
        }}
        img {{
            max-width: 100%;
            height: auto;
            margin: 20px 0;
        }}
    </style>
</head>
<body>
    <div class="container">
        <h2>도어 데이터</h2>
        <!-- 그림 -->
        <img src="door_diagram.png" alt="도어 다이어그램">
        
        <!-- 데이터 표 -->
        <table>
            <tr><th>항목</th><th>값</th></tr>
            <tr><td>가로 외경 (Wide)</td><td class="highlight">{wide} mm</td></tr>
            <tr><td>세로 외경 (High)</td><td class="highlight">{high} mm</td></tr>
            <tr><td>좌 픽스 유리 가로 (Wide Fix Glass)</td><td>{wide_fixglass} mm</td></tr>
            <tr><td>좌 픽스 유리 세로 (High Fix Glass)</td><td>{high_fixglass} mm</td></tr>
            <tr><td>걸레받이 치수 (Auto Fix Habar)</td><td>{autofixhabar} mm</td></tr>
            <tr><td>도어 유리 가로 (Wide Door Glass)</td><td>{wide_doorglass} mm</td></tr>
            <tr><td>도어 유리 세로 (High Door Glass)</td><td>{high_doorglass} mm</td></tr>
            <tr><td>오픈 사이즈 (Open Size)</td><td class="highlight">{opensize} mm</td></tr>
            <tr><td>도어 검측 높이 (Door High)</td><td>{doorhigh} mm</td></tr>
            <tr><td>바닥 묻힘 (Floor)</td><td>{floor}</td></tr>
        </table>
    </div>
</body>
</html>
"""

# Save HTML content to a file
with open("door_data.html", "w", encoding="utf-8") as file:
    file.write(html_content)

print("HTML and diagram successfully created!")
