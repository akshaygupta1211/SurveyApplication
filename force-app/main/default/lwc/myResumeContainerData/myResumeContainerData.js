import SOCIAL from '@salesforce/resourceUrl/SOCIAL';
import akshay from '@salesforce/resourceUrl/akshay';
export const PROFILE_IMAGE = akshay;

export const SOCIAL_LINKS=[
    {
        type: "github",
        label: "github/akshaygupta",
        link: "https://github.com/akshaygupta-dev",
        icon: SOCIAL + '/SOCIAL/github.svg'
    },
    {
        type: "linkedin",
        label: "linkedin/akshaygupta",
        link: "https://www.linkedin.com/",
        icon: SOCIAL + '/SOCIAL/linkedin.svg'
    },
    {
        type: "trailhead",
        label: "trailhead/akshaygupta",
        link: "https://trailblazer.me/id/akshaygupta",
        icon: SOCIAL + '/SOCIAL/trailhead.svg'
    }
];

export const USER_DETAILS={
    NAME:'Akshay Gupta',
    ROLE:'Salesforce Developer',
    EMAIL:'akshaygupta@outlook.com',
    PHONE:'+91 9876543210'
};

export const CAREER_SUMMARY={
    HEADING:"CAREER SUMMARY",
    DESCRIPTION: "Certified Salesforce Developer and Administrator with experience working in telecom and education industries.",
    KEYS_POINTS:[
    ]
};

export const EXPERIENCE_DATA={
    HEADING: "Work Experience",
    EXPERIENCES: [
        {
            ROLE: "Software Engineer",
            COMPANY_NAME: "XYZ Inc.",
            DURATION: "2021 - Present",
            DESCRIPTION:
                "Working primarily as a Salesforce and Cloudsense developer, also acting as SME for improving security posture of our org.",
            DESCRIPTION_POINTS: [
            ],
            TECHNOLOGIES_USED: {
                HEADING: 'Technologies used',
                LIST: [
                    "Apex",
                    "Lightning Flows",
                    "LWC",
                    "HTML5/CSS",
                    "SOQL",
                    "Javascript"
                ]
            },
        },
        {
            ROLE: "Associate Consultant",
            COMPANY_NAME: "ABC Industries",
            DURATION: "2019 - 2021",
            DESCRIPTION:
                "Worked as a Salesforce Developer and Administrator, developed custom solution using LWC and Aura. Participated in the devops team as release manager and also performed data migration.",
            DESCRIPTION_POINTS: [
            ],
            TECHNOLOGIES_USED: {
                HEADING: 'Technologies used',
                LIST: [
                    "Apex",
                    "Lightning Flows",
                    "LWC",
                    "HTML5/CSS",
                    "SOQL",
                    "Aura",
                    "Experience Sites",
                    "Git",
                    "Bitbucket",
                    "Pardot",
                    "REST API",
                    "Javascript"
                ]
            }
        },
    ]
};


 export const EDUCATION_DATA={
     ICON: SOCIAL + '/SOCIAL/education.svg',
     HEADING: "EDUCATION",
     LIST:[
         {
             NAME: "Bachelors in Electronics and Communication Engineering",
             UNIVERSITY_NAME: "National Institute of Technology",
             DURATION: "2015 - 2019",
         }
     ]
 };

export const CERTIFICATION_DATA={
    ICON: SOCIAL + '/SOCIAL/certification.svg',
    HEADING: "CERTIFICATIONS",
    LIST: [
        {
            NAME: "Salesforce Platform Developer II",
        },
        {
            NAME: "Salesforce Platform Developer I",
        },
        {
            NAME: "Salesforce Platform App Builder",
        },
        {
            NAME: "Microsoft Azure Developer Associate",
        },
        {
            NAME: "Copado Developer",
        },
        {
            NAME: "Copado Administrator",
        }        
    ]
};

export const LANGUAGES_DATA={
    HEADING: "Languages",
    LIST: [
        {
            NAME: "Hindi",
            LEVEL: "Native",
        },
        {
            NAME: "English",
            LEVEL: "Professional",
        }
    ]
};

export const SKILLS_DATA ={
    HEADING: "SKILLS & TOOLS",
    SKILLS:[
        {
            HEADING: "FRONTEND",
            SKILLS_LIST: [
                { NAME: "JavaScript", LEVEL: "89" },
                { NAME: "HTML5/CSS3", LEVEL: "90" },
            ],
        },
        {
            HEADING: "BACKEND",
            SKILLS_LIST: [
                { NAME: "Python/Flask", LEVEL: "80" }
            ],
        },
        {
            HEADING: "CRM/CMS",
            SKILLS_LIST: [
                { NAME: "Salesforce", LEVEL: "90" }
            ],
        },
        {
            HEADING: "Cloud",
            SKILLS_LIST: [
                { NAME: "AWS", LEVEL: "50" }
            ],
        }        
    ],
    OTHERS_SKILLS:{
        HEADING: 'OTHERS',
        SKILLS_LIST: [
            "Git",
            "Salesforce",
            "Docker",
            "JIRA",
            "Bitbucket",
            "Confluence"
        ]
    }
};

export const INTERESTS_DATA = {
    HEADING: "Interests",
    LIST: ["Reading", "Gaming"]
};