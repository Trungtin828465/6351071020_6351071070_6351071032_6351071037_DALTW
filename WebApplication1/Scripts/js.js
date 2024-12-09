// JavaScript for the first slider
let indexOne = 0;
const rightBtnOne = document.querySelector(".fa-chevron-right-one");
const leftBtnOne = document.querySelector(".fa-chevron-left-one");
const sliderContainerOne = document.querySelector(
    ".slider-product-one .slider-wrapper-content"
);
const imgNumOne = document.querySelectorAll(
    ".slider-product-one .slider-items"
);
const itemsCountOne = imgNumOne.length;

rightBtnOne.addEventListener("click", function () {
    indexOne = (indexOne + 1) % itemsCountOne;
    updateSliderPositionOne();
});

leftBtnOne.addEventListener("click", function () {
    indexOne = (indexOne - 1 + itemsCountOne) % itemsCountOne;
    updateSliderPositionOne();
});

function updateSliderPositionOne() {
    const offset = indexOne * 100;
    sliderContainerOne.style.transform = `translateX(-${offset}%)`;
}

//2
let indexTwo = 0;
const rightBtnTwo = document.querySelector(".fa-chevron-right-two");
const leftBtnTwo = document.querySelector(".fa-chevron-left-two");
const sliderContainerTwo = document.querySelector(
    ".slider-product-two .slider-wrapper-content"
);
const imgNumTwo = document.querySelectorAll(
    ".slider-product-two .slider-items"
);
const itemsCountTwo = imgNumTwo.length;

rightBtnTwo.addEventListener("click", function () {
    indexTwo = (indexTwo + 1) % itemsCountTwo;
    updateSliderPositionTwo();
});

leftBtnTwo.addEventListener("click", function () {
    indexTwo = (indexTwo - 1 + itemsCountTwo) % itemsCountTwo;
    updateSliderPositionTwo();
});

function updateSliderPositionTwo() {
    const offset = indexTwo * 100;
    sliderContainerTwo.style.transform = `translateX(-${offset}%)`;
}
// 3
let indexThird = 0;
const rightBtnThird = document.querySelector(".fa-chevron-right-third");
const leftBtnThird = document.querySelector(".fa-chevron-left-third");
const sliderContainerThird = document.querySelector(
    ".slider-product-third .slider-wrapper-content"
);
const imgNumThird = document.querySelectorAll(
    ".slider-product-third .slider-items"
);
const itemsCountThird = imgNumThird.length;

rightBtnThird.addEventListener("click", function () {
    indexThird = (indexThird + 1) % itemsCountThird;
    updateSliderPositionThird();
});

leftBtnThird.addEventListener("click", function () {
    indexThird = (indexThird - 1 + itemsCountThird) % itemsCountThird;
    updateSliderPositionThird();
});

function updateSliderPositionThird() {
    const offset = indexThird * 100;
    sliderContainerThird.style.transform = `translateX(-${offset}%)`;
}
//4

let indexFourth = 0;
const rightBtnFourth = document.querySelector(".fa-chevron-right-fourth ");
const leftBtnFourth = document.querySelector(".fa-chevron-left-fourth ");
const sliderContainerFourth = document.querySelector(
    ".slider-product-fourth .slider-wrapper-content"
);
const imgNumFourth = document.querySelectorAll(
    ".slider-product-fourth .slider-items"
);
const itemsCountFourth = imgNumFourth.length;

rightBtnFourth.addEventListener("click", function () {
    indexFourth = (indexFourth + 1) % itemsCountFourth;
    updateSliderPositionFourth();
});

leftBtnFourth.addEventListener("click", function () {
    indexFourth = (indexFourth - 1 + itemsCountFourth) % itemsCountFourth;
    updateSliderPositionFourth();
});

function updateSliderPositionFourth() {
    const offset = indexFourth * 100;
    sliderContainerFourth.style.transform = `translateX(-${offset}%)`;
}
//5
// hieu ung xuat hien anh tinh te lich lam

document.addEventListener("DOMContentLoaded", () => {
    const elements = document.querySelectorAll(".body-anh div");

    function checkVisibility() {
        const windowHeight = window.innerHeight;
        const scrollTop = window.scrollY;

        elements.forEach((element) => {
            const elementTop = element.getBoundingClientRect().top + scrollTop;

            if (scrollTop + windowHeight > elementTop) {
                element.classList.add("show");
            }
        });
    }

    window.addEventListener("scroll", checkVisibility);
    checkVisibility(); // Kiểm tra khi tải trang
});
//Hiệu ứng xuất hiện ảnh gmt

document.addEventListener("DOMContentLoaded", function () {
    const observer = new IntersectionObserver((entries) => {
        entries.forEach((entry) => {
            if (entry.isIntersecting) {
                if (entry.target.classList.contains("textgmt")) {
                    entry.target.classList.add("text-animated");
                } else if (entry.target.classList.contains("anhgmt")) {
                    entry.target.classList.add("image-animated");
                }
                observer.unobserve(entry.target);
            }
        });
    });

    const textTarget = document.querySelector(".textgmt");
    const imageTarget = document.querySelector(".anhgmt");
    if (textTarget) observer.observe(textTarget);
    if (imageTarget) observer.observe(imageTarget);
});
