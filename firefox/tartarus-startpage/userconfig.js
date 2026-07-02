let saved_config = JSON.parse(localStorage.getItem("CONFIG"));

const default_config = {
  overrideStorage: true,
  temperature: {
    location: 'Moscow,RU',
    scale: "C",
  },
  clock: {
    format: "h:i p",
    iconColor: "#ea6962",
  },
  search: {
    engines: {
      g: ["https://google.com/search?q=", "Google"],
      d: ["https://duckduckgo.com/html?q=", "DuckDuckGo"],
      y: ["https://youtube.com/results?search_query=", "Youtube"],
      r: ["https://www.reddit.com/search/?q=", "Reddit"],
      p: ["https://www.pinterest.es/search/pins/?q=", "Pinterest"],
    },
  },
  keybindings: {
    "s": "search-bar",
    "q": "config-tab",
  },
  disabled: [],
  localIcons: false,
  fastlink: "https://claude.ai/",
  openLastVisitedTab: true,
  tabs: [

{
      name: "work",
      background_url: "src/img/banners/cbg-6.gif",
      categories: [
        {
          name: "main",
          links: [
            {
              name: "bitrix 24",
              url: "https://bitrix24.srg-eco.ru/",
              icon: "brand-bitrix24",
              icon_color: "#7daea3",
            },
            {
              name: "snas01",
              url: "https://cloud.srgroup.ru:7001/",
              icon: "folder",
              icon_color: "#f0c674",
            },
	    {
              name: "snas02",
              url: "https://cloud.srgroup.ru/",
              icon: "folder",
              icon_color: "#f0c674",
            },
            {
              name: "exchange",
              url: "https://mail.srgroup.ru/ecp/",
              icon: "mail-cog",
              icon_color: "#505fde",
            },
            {
              name: "ipecs",
              url: "http://192.168.1.57:2077/systempwd.html",
              icon: "phone",
              icon_color: "#e78a4e",
            },
          ],
        },
        {
          name: "admin",
          links: [
	    {
              name: "crocotime",
              url: "https://crocotime.infomaximum.com/",
              icon: "clock-hour-2",
              icon_color: "#d3869b",
            },
            {
              name: "nextcloud",
              url: "https://ncloud.srgroup.ru/",
              icon: "brand-nextcloud",
              icon_color: "#7daea3",
             },
             {
              name: "elastic",
              url: "http://192.168.1.35:5601/",
              icon: "brand-elastic",
              icon_color: "#c5c8c6",
            },
            {
              name: "zabbix",
              url: "http://192.168.1.35/",
              icon: "letter-z",
              icon_color: "#ea6962",
            },
            {
              name: "proxmox",
              url: "http://192.168.0.158:8006/",
              icon: "xbox-x",
              icon_color: "#e78a4e",
            },
          ],
        },
        {
          name: "other",
          links: [
            {
              name: "mail",
              url: "https://mail.srgroup.ru/owa/",
              icon: "mail",
              icon_color: "#505fde",
            },
	    {
              name: "transfam",
              url: "https://www.fotosav.ru/services/transliteration.aspx",
              icon: "language-hiragana",
              icon_color: "#a9b665",
            },
	    {
              name: "genpass",
              url: "http://www.onlinepasswordgenerator.ru/",
              icon: "lock",
              icon_color: "#a9b665",
            },
	    {
              name: "1c",
              url: "https://srg-consulting.1c-cabinet.ru/applications/468-305?login_hint=РоманенкоРВ",
              icon: "letter-c",
              icon_color: "#ea6962",
            },
        {
              name: "modplus",
              url: "https://lsm.modplus.org/",
              icon: "letter-m",
              icon_color: "#7daea3",
            },
        {
              name: "futurebim",
              url: "https://futurebim.ru/ru/account/login",
              icon: "hourglass",
              icon_color: "#a9b665",
            },
	{
              name: "bim-starter",
              url: "https://bim-starter.com/cabinet",
              icon: "brand-booking",
              icon_color: "#d3869b",
            },


          ],
        },
      ],
    },

{
      name: "res",
      background_url: "src/img/banners/cbg-10.gif",
      categories: [
        {
          name: "repositories",
          links: [
            {
              name: "github",
              url: "https://github.com/",
              icon: "brand-github",
              icon_color: "#7daea3",
            },
            {
              name: "gitlab",
              url: "https://gitlab.com/",
              icon: "brand-gitlab",
              icon_color: "#e78a4e",
            },
          ],
        },
        {
          name: "progs",
          links: [
            {
              name: "microsoft",
              url: "https://softnet.su/download/",
              icon: "brand-windows",
              icon_color: "#7daea3",
            },
            {
              name: "hackprogs",
              url: "https://pcprogs.net/",
              icon: "brand-adobe",
              icon_color: "#ea6962",
            },
            {
              name: "pirprogs",
              url: "https://lavteam.org/",
              icon: "text-size",
              icon_color: "#7daea3",
            },
            {
              name: "vscode",
              url: "https://vscode.dev/",
              icon: "brand-vscode",
              icon_color: "#7daea3",
            },
          ],
        },
        {
          name: "challenges",
          links: [
            {
              name: "hackthebox",
              url: "https://app.hackthebox.com",
              icon: "box",
              icon_color: "#a9b665",
            },
            {
              name: "cryptohack",
              url: "https://cryptohack.org/challenges/",
              icon: "brain",
              icon_color: "#e78a4e",
            },
            {
              name: "tryhackme",
              url: "https://tryhackme.com/dashboard",
              icon: "brand-onedrive",
              icon_color: "#ea6962",
            },
            {
              name: "hackerrank",
              url: "https://www.hackerrank.com/dashboard",
              icon: "code-asterix",
              icon_color: "#a9b665",
            },
          ],
        },
      ],
    },


    {
      name: "chi ll",
      background_url: "src/img/banners/cbg-2.gif",
      categories: [{
        name: "Social Media",
        links: [
          {
            name: "whatsapp",
            url: "https://web.whatsapp.com/",
            icon: "brand-whatsapp",
            icon_color: "#a9b665",
          },
          {
            name: "telegram",
	    url: "https://web.telegram.org/",
            icon: "brand-telegram",
            icon_color: "#7daea3",
          },
          {
            name: "reddit",
            url: "https://www.reddit.com/",
            icon: "brand-reddit",
            icon_color: "#e78a4e",
          },
          {
            name: "youtube",
            url: "https://www.youtube.com/",
            icon: "brand-youtube-filled",
            icon_color: "#ea6962",
          },
          {
            name: "twitch",
            url: "https://www.twitch.tv/",
            icon: "brand-twitch",
            icon_color: "#d3869b",
          },
        ],
      }, {
        name: "Games",
        links: [
          {
            name: "chess",
            url: "https://www.chess.com/home",
            icon: "chess-queen-filled",
            icon_color: "#a9b665",
          },
          {
            name: "monkeytype",
            url: "https://monkeytype.com/",
            icon: "keyboard",
            icon_color: "#e78a4e",
          },
          {
            name: "tetris",
            url: "https://tetris.com/",
            icon: "brand-apple-arcade",
            icon_color: "#ea6962",
          },
        ],
      }, {
        name: "Video",
        links: [
          {
            name: "disney+",
            url: "https://www.disneyplus.com/home",
            icon: "brand-disney",
            icon_color: "#7daea3",
          },
          {
            name: "primevideo",
            url: "https://www.primevideo.com/region/eu/?ref_=dv_web_unknown",
            icon: "brand-amazon",
            icon_color: "#7daea3",
          },
        ],
      }],
    },
   {
      name: "myself",
      background_url: "src/img/banners/cbg-9.gif",
      categories: [
        {
          name: "mails",
          links: [
            {
              name: "gmail",
              url: "https://mail.google.com/mail/u/0/",
              icon: "brand-gmail",
              icon_color: "#ea6962",
            },
          ],
        },
        {
          name: "cons",
          links: [
            {
              name: "iconslinux",
              url: "https://www.nerdfonts.com/cheat-sheet/",
              icon: "bomb",
              icon_color: "#f0c674",
            },
            {
              name: "iconsfirefox",
              url: "https://tabler.io/icons",
              icon: "brand-tabler",
              icon_color: "#7daea3",
            },
            {
              name: "fotos",
              url: "https://photos.google.com/u/1",
              icon: "photo-filled",
              icon_color: "#ea6962",
            },
          ],
        },
        {
          name: "stuff",
          links: [
            {
              name: "linkedin",
              url: "https://www.linkedin.com/feed/",
              icon: "brand-linkedin",
              icon_color: "#7daea3",
            },
	    {
              name: "colorhunt",
              url: "https://colorhunt.co/",
              icon: "color-picker",
              icon_color: "#ea6962",
            },
	    {
              name: "terminalsexy",
              url: "https://terminal.sexy",
              icon: "prompt",
              icon_color: "#e78a4e",
            },
          ],
        },
      ],
    },
  ],
};

const CONFIG = new Config(saved_config ?? default_config);
// const CONFIG = new Config(default_config);

(function() {
  var css = document.createElement('link');
  css.href = 'src/css/tabler-icons.min.css';
  css.rel = 'stylesheet';
  css.type = 'text/css';
  if (!CONFIG.config.localIcons)
    document.getElementsByTagName('head')[0].appendChild(css);
})();
