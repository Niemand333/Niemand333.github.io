
function setRandomBackgroundColor() {
    const colors = ['rgb(68, 119, 206)',
                    'rgb(19, 126, 96)',
                    'rgb(52, 13, 61)',
                    'rgb(45, 76, 85)',
    ];

    const elements = document.getElementsByClassName('project-grid-item');
    
    for (let i = 0; i < elements.length; i++) {
        const randomColor = colors[Math.floor(Math.random() * colors.length)];
        elements[i].style.backgroundColor = randomColor;
    }
}


setRandomBackgroundColor();