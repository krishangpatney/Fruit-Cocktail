<div id="top"></div>
<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
<!-- [![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url] -->
<!-- [![MIT License][license-shield]][license-url] -->
<!-- [![LinkedIn][linkedin-shield]][linkedin-url]
 -->


<!-- PROJECT LOGO -->
<br />
<div align="center">
<!--   <a href="https://github.com/othneildrew/Best-README-Template">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>
 -->
  <h3 align="center">Level 4 - Honours Student Project</h3>

  <p align="center">
    Optimised Microservice Deployment in the Cloud
    <br />
    <a><strong>Supervisor : Yehia Elkhatib »</strong></a>

    <br />
<!--     <a href="https://github.com/othneildrew/Best-README-Template">View Demo</a>
    ·
    <a href="https://github.com/othneildrew/Best-README-Template/issues">Report Bug</a>
    ·
    <a href="https://github.com/othneildrew/Best-README-Template/issues">Request Feature</a> -->
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<!-- <details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>
 -->


<!-- ABOUT THE PROJECT -->
## About The Project

<!-- [![Product Name Screen Shot][product-screenshot]](https://example.com)
 -->
Using microservices is currently the prevalent architecture, this architectural style structures an application as a collection of services that are Highly maintainable and testable, loosely coupled and allow to be independently deployable. Which present new challanges of their own, hence this project investigates the differentways in which a cloud application with a microservice architecture could be deployed in an optimal way to the datacenter. 

<p align="right">(<a href="#top">back to top</a>)</p>

### Built With

This section lists major frameworks/libraries used to bootstrap the project.

* [Terraform](https://www.terraform.io/)
* [Microsoft Azure](https://azure.microsoft.com/en-gb/)

<p align="right">(<a href="#top">back to top</a>)</p>

## Top-level directory layout

<pre>├── <font color="#3465A4"><b>L4-Dissertation</b></font>
├── <font color="#3465A4"><b>meetings</b></font>
│   ├── meeting_06_10_21.md
│   ├── meeting_09_11_21.md
│   ├── meeting_12_10_21.md
│   ├── meeting_19_10_21.md
│   ├── meeting_26_10_21.md
│   ├── meeting_27_10_21.md
│   └── meeting_28_09_21.md
├── README.md
├── <font color="#3465A4"><b>src</b></font>
│   ├── manual.md
│   ├── readme.md
│   └── <font color="#3465A4"><b>scripts</b></font>
│       ├── <font color="#3465A4"><b>azure_pricing</b></font>
│       │   ├── main.py
│       │   ├── README.md
│       │   └── requirements.txt
│       ├── <font color="#3465A4"><b>py_scripts</b></font>
│       │   └── viz_cpu_mem.py
│       ├── <font color="#3465A4"><b>start_up</b></font>
│       │   └── setup.sh
│       ├── <font color="#3465A4"><b>tf_robot_shop_01</b></font>
│       │   ├── <font color="#3465A4"><b>files</b></font>
│       │   │   ├── reverse
│       │   │   └── setup.sh
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   ├── README.md
│       │   ├── terraform.tfstate
│       │   ├── terraform.tfstate.backup
│       │   ├── terraform.tfvars
│       │   └── variables.tf
│       └── <font color="#3465A4"><b>tf_robot_shop_multiple</b></font>
│           ├── main.tf
│           ├── README.md
│           ├── <font color="#3465A4"><b>scripts</b></font>
│           │   └── rs_install.sh
│           ├── terraform.tfvars
│           └── variables.tf
└── timelog.md
</pre>

<p align="right">(<a href="#top">back to top</a>)</p

<!-- ROADMAP -->
## Roadmap

See the [open issues](https://github.com/othneildrew/Best-README-Template/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- LICENSE -->
<!-- ## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>

 -->

<!-- CONTACT -->
<!-- ## Contact

Your Name - [@your_twitter](https://twitter.com/your_username) - email@example.com

Project Link: [https://github.com/your_username/repo_name](https://github.com/your_username/repo_name)

<p align="right">(<a href="#top">back to top</a>)</p> -->



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

* [What are microservices?](https://microservices.io/)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
<!-- [contributors-shield]: https://img.shields.io/github/contributors/othneildrew/Best-README-Template.svg?style=for-the-badge
[contributors-url]: https://github.com/othneildrew/Best-README-Template/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/othneildrew/Best-README-Template.svg?style=for-the-badge
[forks-url]: https://github.com/othneildrew/Best-README-Template/network/members
[stars-shield]: https://img.shields.io/github/stars/othneildrew/Best-README-Template.svg?style=for-the-badge
[stars-url]: https://github.com/othneildrew/Best-README-Template/stargazers
[issues-shield]: https://img.shields.io/github/issues/othneildrew/Best-README-Template.svg?style=for-the-badge
[issues-url]: https://github.com/othneildrew/Best-README-Template/issues
[license-shield]: https://img.shields.io/github/license/othneildrew/Best-README-Template.svg?style=for-the-badge
[license-url]: https://github.com/othneildrew/Best-README-Template/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/othneildrew
[product-screenshot]: images/screenshot.png
 -->
