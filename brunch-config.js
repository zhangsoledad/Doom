exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      // To use a separate vendor.js bundle, specify two files path
      // https://github.com/brunch/brunch/blob/stable/docs/config.md#files
      joinTo: {
        "js/app.js": /^(web\/static\/js)|(node_modules)/,
        "js/vendor.js": /^(web\/static\/vendor)/
      },
      //
      // To change the order of concatenation of files, explicitly mention here
      // https://github.com/brunch/brunch/tree/master/docs#concatenation
      order: {
        before: [
          "web/static/vendor/js/jquery-2.2.1.min.js",
          "web/static/vendor/js/bootstrap.min.js",
          "web/static/vendor/js/jquery.slimscroll.js",
          "web/static/vendor/js/fastclick.js",
          "web/static/vendor/js/admin-lte.js",
          "web/static/vendor/js/icheck.js",
          "web/static/vendor/js/chosen.jquery.js"
        ]
      }
    },
    stylesheets: {
      joinTo: "css/app.css",
      order: {
        before: [
          "web/static/vendor/css/bootstrap.min.css",
          "web/static/vendor/css/font-awesome.min.css",
          "web/static/vendor/css/ionicons.css",
          "web/static/vendor/css/admin-lte.css",
          "web/static/vendor/css/skin-blue.css",
          "web/static/vendor/css/minimal.css",
          "web/static/vendor/css/chosen.css",
          "web/static/css/app.css"
        ] // concat app.css last
      }
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/web/static/assets". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: /^(web\/static\/assets)/
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: [
      "web/static",
      "test/static"
    ],

    // Where to compile files to
    public: "priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/web\/static\/vendor/]
    },
    sass: {
      precision: 8,
      allowCache: true
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["web/static/js/app"]
    }
  },

  npm: {
    enabled: true
  }
};
