/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import StartOptions from '@ohos.app.ability.StartOptions';
import display from '@ohos.display';
import { BusinessError } from '@ohos.base';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { i18n } from '@kit.LocalizationKit';
import { AbilityConstant } from '@kit.AbilityKit';
import settings from '@ohos.settings';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { DeviceHelper,localEventManager } from '@ohos/frameworkwrapper';
import { LengthMetrics } from '@kit.ArkUI';
import { MenuStyle } from '@ohos/plugincomponent/src/main/ets/style/MenuStyle';
import { StyleConstants } from '@ohos/launchercommon';

class StyleRule {
  public hoverColor?: Color | string;
  public clickColor?: Color | string;
  public transparentColor?: Color | string;
}

const BUNDLE_NAME: string = '';
const SEARCH_BUNDLE_NAME: string = 'com.ohos.hisearch';
const ABILITY_PC: string = '';
const ABILITY_TABLET: string = '';
const PC_SERVICE_ABILITY: string = '';
const PC_TRANSLATE_ABILITY: string = '';
const SEARCH_ABILITY: string = 'MainAbility';
const VOICE_SETTING_ABILITY: string = '';
const PLUGIN_CLICK: string = 'Plguin';
const ELEMENT_NAME: string = '18';
const CLICK_TYPE: string = '2';
const TAG: string = 'PluginAI';
const HPR_C_DISPLAY_ID: number = 999;
const PAGE_STATUS: string = '4';
const WINDOW_WIDTH_INIT: number = 362;
const WINDOW_HEIGHT_INIT: number = 732;
const WINDOW_TOP_OFFSET: number = 8;
const WINDOW_LEFT_MARGIN: number = 8;
const HPR_WINDOW_LEFT_MARGIN: number = 8;
const HPR_WINDOW_TOP_OFFSET: number = 8;
const FOLD_SCREEN_FLAG: String = systemParameterEnhance.getSync('const.window.foldscreen.type', '0,0,0,0');

const style: StyleRule = {
  hoverColor: '#0C000000',
  clickColor: '#19000000',
  transparentColor: Color.Transparent,
};

const HOVER_ANIMATION_SCALE = 1.15;
const CLICK_ANIMATION_SCALE = 0.9;
const NORMAL_SCALE = 1;
const ITERATIONS = 1;
const ANIMATION_DURATION_TIME = 200;
const MARGIN_TOP_BOTTOM = 16;
const MAC_TOP_MARGIN: number = 4;
const TOP_DOCK_HEIGHT: number = 40;
const DOCK_HEIGHT: number = 73;
const MIDDLE_SIGN: number = 45.55; // hopper中轴区高度
const DEFAULT_DISPLAY_ID = 999;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
// 每帧持续时间(ms)
const FRAME_DURATION: number = 33;
const IMG_LIST_LENGTH: number = 690;
const BALL_SIZE: number = 40;
const INDEX_LEN: number = 3;

@Entry
@Component
export struct PcAIAssistantPage {
  @State isIconHover: boolean | undefined = false;
  @State isClicked: boolean = false;
  @State scaleX: number = 1;
  @State scaleY: number = 1;
  @State imgRes: Resource = $r('sys.symbol.AI_translate');
  @State screenHeight: number = vp2px(1000);
  hoverScaleEnable: boolean = true;
  clickScaleEnable: boolean = true;
  // 序列帧相关状态
  @State currentFrameIndex: number = 0;
  @State isAnimating: boolean = false;
  private animationTimer: number | null = null;
  private imgList: Array<ImageFrameInfo> = [];
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  @State isMenuShow: boolean = false;
  @State divideMetrics: LengthMetrics = new LengthMetrics(0);
  menuStyle: MenuStyle = new MenuStyle();

  aboutToAppear(): void {
    log.info(TAG, 'aboutToAppear');
    this.updateImgBySetting();
    this.imgListInit();
  }

  private imgListInit(): void {
    const prefix: string = 'app.media.voiceball_';
    for (let i = 0; i < IMG_LIST_LENGTH; i++) {
      let indexStr = i.toString().padStart(INDEX_LEN, '0');
      this.imgList.push({ src: $r(prefix + indexStr), duration: FRAME_DURATION });
    }
  }

  private updateImgBySetting() {
    this.imgRes = $r('sys.symbol.AI_translate');
    this.hoverScaleEnable = false;
    this.isIconHover = false;
    this.clickScaleEnable = false;
  }

  aboutToDisappear() {
    log.info(TAG, 'aboutToDisappear');
  }

  public onBackgroundColorChange(): ResourceColor {
    if (this.isClicked) {
      return style.clickColor as ResourceColor;
    }
    if (this.isIconHover) {
      return style.hoverColor as ResourceColor;
    }
    return style.transparentColor as ResourceColor;
  }

  onIconClick() {
    if (this.clickScaleEnable) {
      animateTo({
        duration: ANIMATION_DURATION_TIME,
        curve: Curve.Sharp,
        iterations: ITERATIONS,
        playMode: PlayMode.Normal,
        onFinish: () => {
          this.isClicked = false;
          this.scaleX = HOVER_ANIMATION_SCALE;
          this.scaleY = HOVER_ANIMATION_SCALE;
        }
      }, () => {
        this.isClicked = true;
        this.scaleX = CLICK_ANIMATION_SCALE;
        this.scaleY = CLICK_ANIMATION_SCALE;
      });
    }
    const ability: string = DeviceHelper.is2In1DevicePcType() ? ABILITY_TABLET : ABILITY_PC;
    let voicePCWant: Want = {
      bundleName: BUNDLE_NAME,
      abilityName: ability,
      parameters: {
        launch_type: PLUGIN_CLICK,
        elementName: ELEMENT_NAME,
        clickType: CLICK_TYPE,
        pageName: TAG,
        pageStatus: PAGE_STATUS
      }
    };
    try {
      let displayId: number = display.getDefaultDisplaySync()?.id;
      let context = getContext() as common.ServiceExtensionContext;
      let currentDisplayId: number | undefined = context.config?.displayId;
      if (typeof (currentDisplayId) === 'number' && currentDisplayId >= 0) {
        displayId = currentDisplayId;
      }
      log.showInfo(`displayId：${displayId}`);
      let displayInfo: display.Display = display.getDisplayByIdSync(displayId);

      let promise = displayInfo.getAvailableArea();
      promise.then(async (data) => {
        let densityDPI: number = displayInfo.densityDPI;
        let vp2pxChange = densityDPI / 160;
        this.screenHeight = data.height;
        let offsetLeft: number =
          i18n.isRTL(i18n.System.getAppPreferredLanguage()) ? vp2px(WINDOW_LEFT_MARGIN) :
            displayInfo.width - vp2pxChange * WINDOW_WIDTH_INIT - vp2px(WINDOW_LEFT_MARGIN);
        let height: number =
          Math.min(vp2pxChange * WINDOW_HEIGHT_INIT, this.screenHeight - vp2px(WINDOW_TOP_OFFSET) * 2);
        let reduceHeight: number =  this.screenHeight - height - vp2px(WINDOW_TOP_OFFSET);
        let offsetTop: number = reduceHeight
        let width: number = vp2pxChange * WINDOW_WIDTH_INIT;
        if (FOLD_SCREEN_FLAG === '5,2,0,0') {
          if (display.getFoldStatus() !== display.FoldStatus.FOLD_STATUS_EXPANDED) {
            let displays = await display.getAllDisplays();
            displays.forEach(displayObj => {
              log.showInfo(TAG, 'displayId:' + displayObj.id);
              if (displayObj.id === HPR_C_DISPLAY_ID) {
                displayId = HPR_C_DISPLAY_ID
                this.screenHeight = display.getDisplayByIdSync(HPR_C_DISPLAY_ID).availableHeight;
              }
            })
          }
          height = Math.min(vp2pxChange * WINDOW_HEIGHT_INIT, this.screenHeight - vp2px(HPR_WINDOW_TOP_OFFSET) * 2);
          offsetLeft = i18n.isRTL(i18n.System.getAppPreferredLanguage()) ? vp2px(HPR_WINDOW_LEFT_MARGIN) :
            displayInfo.width - width - vp2px(HPR_WINDOW_LEFT_MARGIN);
          offsetTop = this.screenHeight - height - vp2px(HPR_WINDOW_TOP_OFFSET);
        }
        let voicePCOptions: StartOptions = {
          windowLeft: offsetLeft,
          windowTop: offsetTop,
          windowWidth: width,
          windowHeight: height,
          displayId: displayId
        };
        if (this.isSplitScreenEnableSync(getContext()) && FOLD_SCREEN_FLAG !== '5,2,0,0') {
          voicePCOptions.windowMode = AbilityConstant.WindowMode.WINDOW_MODE_SPLIT_SECONDARY;
        }
        if (DeviceHelper.is2In1DevicePcType()) {
          context.startAbility(voicePCWant);
        } else {
          context.startAbility(voicePCWant, voicePCOptions);
        }
      }).catch((err: BusinessError) => {
        log.showError(`error: ${err?.message}, code: ${err?.code}`);
      });
    } catch (err) {
      log.showError(`error: error: ${err?.message}, code: ${err?.code}`);
    }
  }

  public isSplitScreenEnableSync(context: common.Context): boolean {
    let result = false;

    try {
      result = settings.getValueSync(context, 'intell_voice_split_screen_enabled', '0',
        settings.domainName.USER_PROPERTY) === '1';
    } catch (err) {
      log.error(`error: ${err?.message}`);
    }
    return result;
  }

  public getAIWidth(context: common.Context, foldStatus: number): number {
    let width = String(WINDOW_WIDTH_INIT);
    try {
      width = settings.getValueSync(context,
        'AIWidth' + String(foldStatus), String(WINDOW_WIDTH_INIT), settings.domainName.USER_PROPERTY);
    } catch (err) {
      log.error(`error: ${err?.message}`);
    }
    return Number(width);
  }

  hoverAnimation(isHover: boolean) {
    log.info(TAG, `hoverAnimation ${isHover}`);
    if (isHover) {
      animateTo({
        duration: ANIMATION_DURATION_TIME,
        curve: Curve.Friction,
        iterations: ITERATIONS,
        playMode: PlayMode.Normal,
      }, () => {
        this.scaleX = HOVER_ANIMATION_SCALE;
        this.scaleY = HOVER_ANIMATION_SCALE;
      });
    } else {
      animateTo({
        duration: ANIMATION_DURATION_TIME,
        curve: Curve.Friction,
        iterations: ITERATIONS,
        playMode: PlayMode.Normal,
      }, () => {
        this.scaleX = NORMAL_SCALE;
        this.scaleY = NORMAL_SCALE;
      });
    }
  }

  // 开始动画
  startAnimation(): void {
    if (this.isAnimating) {
      return;
    }
    this.isAnimating = true;
    this.playNextFrame();
  }

  // 播放下一帧
  playNextFrame(): void {
    if (!this.isAnimating || this.imgList.length === 0) {
      return;
    }
    this.currentFrameIndex = (this.currentFrameIndex + 1) % this.imgList.length;
    this.animationTimer = setTimeout(() => {
      this.playNextFrame();
    }, FRAME_DURATION) as number;
  }

  // 暂停动画
  pauseAnimation(): void {
    this.isAnimating = false;
    if (this.animationTimer) {
      clearTimeout(this.animationTimer);
      this.animationTimer = null;
    }
  }

  @Builder
  divide() {
    Divider()
      .vertical(false)
      .color($r('sys.color.ohos_id_color_list_separator'))
      .strokeWidth('1px')
      .margin({
        left: StyleConstants.DEFAULT_12,
        right: StyleConstants.DEFAULT_12,
        bottom: StyleConstants.MENU_MARGIN
      })
  }

  @Builder
  operatorMenu() {
    Menu() {
      MenuItemGroup() {
        MenuItem({ content: $r('app.string.voice_notetaker')})
          .onClick(() => {
            let want: Want = {
              bundleName: BUNDLE_NAME,
              abilityName: PC_SERVICE_ABILITY,
              parameters: {
                'launch_type': 'meeting_control'
              }
            }
            this.context.startServiceExtensionAbility(want)
          })
        MenuItem({ content: $r('app.string.voice_translate')})
          .onClick(() => {
            let want: Want = {
              bundleName: BUNDLE_NAME,
              abilityName: PC_TRANSLATE_ABILITY,
            }
            this.context.startAbility(want)
          })
        MenuItem({ content: $r('app.string.voice_search')})
          .onClick(() => {
            let want: Want = {
              bundleName: SEARCH_BUNDLE_NAME,
              abilityName: SEARCH_ABILITY,
            }
            this.context.startAbility(want)
          })
      }
      .margin({
        bottom: StyleConstants.MENU_MARGIN
      })

      this.divide()

      MenuItemGroup() {
        MenuItem({ content: $r('app.string.file_upload')})
          .onClick(() => {
            let want: Want = {
              bundleName: BUNDLE_NAME,
              abilityName: ABILITY_PC,
              parameters: {
                'launch_type': 'file_upload'
              }
            }
            this.context.startAbility(want)
          })
        MenuItem({ content: $r('app.string.settings')})
          .onClick(() => {
            let want: Want = {
              bundleName: BUNDLE_NAME,
              abilityName: VOICE_SETTING_ABILITY,
            }
            this.context.startAbility(want)
          })
      }
      .margin({
        bottom: StyleConstants.MENU_MARGIN
      })
    }
    .onAppear(() => {
      AppStorage.set('isPluginMenuOpen', true);
    })
    .onDisAppear(() => {
      this.isMenuShow = false;
      AppStorage.set('isPluginMenuOpen', false);
      localEventManager.sendLocalEvent('launcher.event.PC_HIDE_DOCK_CALLBACK')
    })
    .menuItemGroupDivider({
      strokeWidth: this.divideMetrics
    })
    .padding({
      left: this.menuStyle.menuContainerLeftPadding,
      right: this.menuStyle.menuContainerRightPadding,
      top: this.menuStyle.menuContainerTopPadding,
      bottom: this.menuStyle.menuContainerBottomPadding,
    })
    .width(this.menuStyle.defaultMenuWidth)
    .borderRadius(this.menuStyle.menuContainerRadius)
  }

  build() {
    Column() {
      Stack() {
        Row()
          .width(TOP_DOCK_HEIGHT)
          .height(TOP_DOCK_HEIGHT)
          .borderRadius(8)
          .backgroundColor(this.onBackgroundColorChange())

        // 序列帧动画容器 - 使用替代方案减少锯齿
        Image(this.imgList[this.currentFrameIndex].src)
          .draggable(false)
          .size({
            width: BALL_SIZE,
            height: BALL_SIZE
          })
          .objectFit(ImageFit.Contain) // 使用合适的缩放模式
          .interpolation(ImageInterpolation.High) // 高质量插值
          .borderRadius(1) // 轻微圆角可以减少尖锐边缘的锯齿感
          .autoResize(false)
          .onHover((isHover: boolean) => {
            if (isHover) {
              this.startAnimation();
            } else {
              this.pauseAnimation();
            }
          })
      }
      .onHover((isHover) => {
        if (!this.hoverScaleEnable) {
          return;
        }
        this.isIconHover = isHover;
        this.hoverAnimation(isHover);
      });
    }
    .bindContextMenu(this.operatorMenu(), ResponseType.RightClick, {
      placement: Placement.TopRight,
      backgroundColor: Color.Transparent,
      backgroundBlurStyle: BlurStyle.COMPONENT_REGULAR
    })
    .bindContextMenu(this.isMenuShow, this.operatorMenu(), {
      placement: Placement.TopRight,
      backgroundColor: Color.Transparent,
      backgroundBlurStyle: BlurStyle.COMPONENT_REGULAR
    })
    .gesture(LongPressGesture({ repeat: false })
      .onAction((event) => {
        if (event?.source === SourceType.Mouse) {
          return;
        }
        this.isMenuShow = true;
      }))
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.onIconClick();
    });
  }
}