/* Patched by YachtNet
 *
 * 24/4/2020 - Added switch option to enable/disable YachtNet functionality
 * 
*/

"use strict";

define(["text!temple/settings/index.html", "css!temple/settings/index.css", "vue", "component/gl-toggle-btn/index", "component/gl-tooltip/index", "component/gl-btn/index", "component/gl-label/index", "component/select/index"], function (stpl, css, Vue, gl_switch, gl_tooltip, gl_btn, gl_label, gl_select) {
    var vueComponent = Vue.extend({
        template: stpl,
        data: function data() {
            return {
                isShow: false,
                chooseState: ["No function (default)", "YachtNet (On/Off)", "WireGuard® Client Toggle (On/Off)", "OpenVPN Client Toggle (On/Off)", "Tor Toggle (On/Off)"],  // yachtnet
                chooseState4G: ["No function (default)", "YachtNet (On/Off)", "WireGuard® Client Toggle (On/Off)", "OpenVPN Client Toggle (On/Off)", ],  // yachtnet
                param: "",
                btnStatus: true,
                paramwifi: "Tor ON",
                paramlet: "Tor OFF",
                paramcontent: "Tor will be turned on.",
                paramcontentlet: "Tor will be turned off."
            };
        },
        components: {
            "gl-switch": gl_switch,
            "gl-tooltip": gl_tooltip,
            "gl-btn": gl_btn,
            "gl-label": gl_label,
            "gl-select": gl_select
        },
        beforeRouteEnter: function beforeRouteEnter(to, from, next) {
            next(function (vm) {
                $("#router-visual").slideUp();
                setTimeout(function () {
                    if ($(".clsLink2" + vm.$route.path.split("/")[1]).hasClass("bar")) {
                        $(".bar.active").removeClass("active");
                        $(".clsLink2" + vm.$route.path.split("/")[1]).addClass("active");
                        $("#vpn").collapse("hide");
                        $("#moresetting").collapse("show");
                        $("#applications").collapse("hide");
                        $("#system").collapse("hide");
                    }
                }, 50);
            });
        },
        computed: {
            router: function router() {
                return this.$store.getters.apiData["router"];
            },
            ise750: function ise750() {
                var item = this.chooseState
                    // item = this.chooseState
                return item
            },
            settingsImage: function settingsImage() {
                var item = '/src/static/images/button-switch-01.png'
                if (this.router.model == 'e750') {
                    item = '/src/static/images/button-switch-02.png'
                }
                return item;
            },
            ststatus: function ststatus() {
                return this.$store.getters.apiData["switchget"];
            },
            parstatus: function parstatus() {
                var status;
                switch (this.param) {
                    case "No function (default)":
                        status = "noop";
                        break;
                    case "YachtNet (On/Off)": // yachtnet
                        status = "yachtnet";  // yachtnet
                        break;                // yachtnet
                    case "WireGuard® Client Toggle (On/Off)":
                        status = "wg";
                        break;
                    case "OpenVPN Client Toggle (On/Off)":
                        status = "vpn";
                        break;
                    case "Tor Toggle (On/Off)":
                        status = "tor";
                        break;
                }
                return status;
            },
            btnStatus: function btnStatus() {
                if (this.parstatus == "vpn") {
                    return true;
                }
                return false;
            }
        },
        mounted: function mounted() {
            var _this = this;
            _this.$store.dispatch("call", {
                api: "switchget"
            }).then(function (result) {
                if (result.success) {
                    switch (result.mode) {
                        case "noop":
                            _this.param = "No function (default)";
                            break;
                        case "yachtnet":                            // yachtnet
                            _this.param = "YachtNet (On/Off)"       // yachtnet
                            break;                                  // yachtnet
                        case "wg":
                            _this.param = "WireGuard® Client Toggle (On/Off)";
                            break;
                        case "vpn":
                            _this.param = "OpenVPN Client Toggle (On/Off)";
                            break;
                        case "tor":
                            _this.param = "Tor Toggle (On/Off)";
                            break;
                    }
                }
            });
        },
        methods: {
            checkBtn: function checkBtn() {
                this.btnStatus = false;
            },
            hint: function hint() {
                this.isShow = !this.isShow;
            },
            checkType: function checkType() {
                var _this = this;
                switch (_this.parstatus) {
                    case 'yachtnet':
                        _this.openSetting();
                        break;
                    case 'wg':
                        _this.$store.dispatch("call", {
                            api: "wgclist"
                        }).then(function (result) {
                            if (result.code == -5) {
                                _this.$store.commit('showModal', {
                                    message: _this.$lang.modal.no_wireguard,
                                    messageTwo: _this.$lang.modal.addnewconfig,
                                    type: 'warning',
                                    title: _this.t(_this.$lang.modal.caution),
                                    cb: function cb() {
                                        _this.$router.push("wgclient");
                                    }
                                });
                            } else {
                                _this.openSetting();
                            }
                        });
                        break;
                    case 'vpn':
                        _this.$store.dispatch("call", {
                            api: "ovpnGetClients"
                        }).then(function (result) {
                            if (result.success) {
                                if (result.clients.length == 0) {
                                    _this.$store.commit('showModal', {
                                        message: _this.$lang.modal.no_openvpn,
                                        messageTwo: _this.$lang.modal.addnewconfig,
                                        type: 'warning',
                                        title: _this.t(_this.$lang.modal.caution),
                                        cb: function cb() {
                                            _this.$router.push("vpnclient");
                                        }
                                    });
                                } else {
                                    _this.openSetting();
                                }
                            } else {
                                _this.openSetting();
                            }
                        });
                        break;
                    case 'noop':
                        _this.openSetting();
                        break;
                    case 'tor':
                        _this.openSetting();
                        break;
                }
            },
            openSetting: function openSetting() {
                var _this = this;
                _this.btnStatus = true;
                _this.$store.dispatch("call", {
                    api: "switchset",
                    data: {
                        mode: _this.parstatus
                    }
                }).then(function (result) {
                    if (result.success) {
                        _this.$message({
                            type: "success",
                            msg: result.code
                        });
                    } else {
                        var type = 'error';
                        if (result.code == -301) {
                            type = 'warning';
                        }
                        _this.$message({
                            type: type,
                            msg: result.code
                        });
                    }
                });
            }
        }
    });
    return vueComponent;
});