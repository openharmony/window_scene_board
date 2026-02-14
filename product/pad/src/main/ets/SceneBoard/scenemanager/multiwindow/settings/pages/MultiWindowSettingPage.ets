/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import sceneSessionManager from '@ohos.sceneSessionManager';
import lottie, { AnimationItem } from '@ohos/lottie';
import { MultiDockSwitchController } from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/multiwindow/settings/controllers/MultiDockSwitchController';
import settings from '@ohos.settings';
import { sSettingsUtil } from '@ohos/frameworkwrapper';
import { SCBConstants } from '@ohos/commonconstants';
import display from '@ohos.display';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { PiPSwitchController } from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/multiwindow/settings/controllers/PiPSwitchController';
import { BusinessError } from '@ohos.base';

let storage = LocalStorage.getShared();
const TAG = 'MultiWindowSettingPage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCS, TAG);

const MULTI_WINDOW_CHANGE_VIEWS_TITLE = 'app.string.MultiWindow_change_views_title';
const MULTI_WINDOW_CHANGE_VIEWS_CONTENTS = 'app.string.MultiWindow_change_views_contents';
const MULTI_WINDOW_FLOATING_WINDOWS_TITLE = 'app.string.MultiWindow_floating_windows_title';
const MULTI_WINDOW_FLOATING_WINDOWS_CONTENTS = 'app.string.MultiWindow_floating_windows_contents';
const MULTI_WINDOW_DOCK_TITLE = 'app.string.MultiWindow_dock_title';
const MULTI_WINDOW_DOCK_CONTENTS = 'app.string.MultiWindow_dock_contents';
const MULTI_WINDOW_SPLIT_SCREEN_TITLE = 'app.string.MultiWindow_split_screen_title';
const MULTI_WINDOW_SPLIT_SCREEN_CONTENTS = 'app.string.MultiWindow_split_screen_contents';
const MULTI_WINDOW_MID_VIEW_TITLE = 'app.string.MultiWindow_Mid_View_title';
const MULTI_WINDOW_MID_VIEW_CONTENTS = 'app.string.MultiWindow_Mid_View_contents';

const CHANGE_VIEWS_PHONE = ['SceneBoard/scenemanager/multiwindow/settings/lottie/multiwindow_change_views_phone.json', MULTI_WINDOW_CHANGE_VIEWS_TITLE, MULTI_WINDOW_CHANGE_VIEWS_CONTENTS];
const FLOATING_WINDOWS_PHONE =
  ['SceneBoard/scenemanager/multiwindow/settings/lottie/multiwindow_floating_windows_phone.json', MULTI_WINDOW_FLOATING_WINDOWS_TITLE, MULTI_WINDOW_FLOATING_WINDOWS_CONTENTS];
const DOCK_PHONE = ['SceneBoard/scenemanager/multiwindow/settings/lottie/multiwindow_dock_phone.json', MULTI_WINDOW_DOCK_TITLE, MULTI_WINDOW_DOCK_CONTENTS];
const SPLIT_SCREEN_PHONE = ['SceneBoard/scenemanager/multiwindow/settings/lottie/multiwindow_split_screen_phone.json', MULTI_WINDOW_SPLIT_SCREEN_TITLE, MULTI_WINDOW_SPLIT_SCREEN_CONTENTS];

const CHANGE_VIEWS_FOLD = ['SceneBoard/scenemanager/multiwindow/settings/lottie/multiwindow_change_views_fold.json', MULTI_WINDOW_CHANGE_VIEWS_TITLE, MULTI_WINDOW_CHANGE_VIEWS_CONTENTS];
const FLOATING_WINDOWS_FOLD =
  ['SceneBoard/scenemanager/multiwindow/settings/lottie/multiwindow_floating_windows_fold.json', MULTI_WINDOW_FLOATING_WINDOWS_TITLE, MULTI_WINDOW_FLOATING_WINDOWS_CONTENTS];
const DOCK_FOLD = ['SceneBoard/scenemanager/multiwindow/settings/lottie/multiwindow_dock_fold.json', MULTI_WINDOW_DOCK_TITLE, MULTI_WINDOW_DOCK_CONTENTS];
const SPLIT_SCREEN_FOLD = ['SceneBoard/scenemanager/multiwindow/settings/lottie/multiwindow_split_screen_fold.json', MULTI_WINDOW_SPLIT_SCREEN_TITLE, MULTI_WINDOW_SPLIT_SCREEN_CONTENTS];
const MID_VIEW_FOLD = ['SceneBoard/scenemanager/multiwindow/settings/lottie/multiwindow_mid_view_fold.json', MULTI_WINDOW_MID_VIEW_TITLE, MULTI_WINDOW_MID_VIEW_CONTENTS];

const CHANGE_VIEWS_PAD = ['SceneBoard/scenemanager/multiwindow/settings/lottie/multiwindow_change_views_pad.json', MULTI_WINDOW_CHANGE_VIEWS_TITLE, MULTI_WINDOW_CHANGE_VIEWS_CONTENTS];
const FLOATING_WINDOWS_PAD = ['SceneBoard/scenemanager/multiwindow/settings/lottie/multiwindow_floating_windows_pad.json', MULTI_WINDOW_FLOATING_WINDOWS_TITLE, MULTI_WINDOW_FLOATING_WINDOWS_CONTENTS];
const DOCK_PAD = ['SceneBoard/scenemanager/multiwindow/settings/lottie/multiwindow_dock_pad.json', MULTI_WINDOW_DOCK_TITLE, MULTI_WINDOW_DOCK_CONTENTS];
const SPLIT_SCREEN_PAD = ['SceneBoard/scenemanager/multiwindow/settings/lottie/multiwindow_split_screen_pad.json', MULTI_WINDOW_SPLIT_SCREEN_TITLE, MULTI_WINDOW_SPLIT_SCREEN_CONTENTS];
const MID_VIEW_PAD = ['SceneBoard/scenemanager/multiwindow/settings/lottie/multiwindow_mid_view_pad.json', MULTI_WINDOW_MID_VIEW_TITLE, MULTI_WINDOW_MID_VIEW_CONTENTS];

const PAGE_BACKGROUND_COLOR = $r('sys.color.ohos_id_color_sub_background');
const TITLE_BAR_BACK_IMG = $r('sys.media.ohos_ic_compnent_titlebar_back');
const TITLE_BAR_FILL_COLOR = $r('sys.color.ohos_id_color_titlebar_text');
const TITLE_BAR_GROUND_COLOR = $r('sys.color.ohos_id_color_button_normal');
const MULTI_WINDOW_TITLE = $r('app.string.MultiWindow_title');
const MULTI_WINDOW_TITLE_FONTSIZE = $r('sys.float.ohos_id_text_size_headline8');
const MULTI_WINDOW_TITLE_FONTCOLOR = $r('sys.color.font_primary');
const SWIPER_TITLE_FONTSIZE = $r('sys.float.Title_S');
const SWIPER_CONTENT_FONTSIZE = $r('sys.float.Body_M');
const SWIPER_CONTENT_FONTCOLOR = $r('sys.color.ohos_id_color_text_secondary');
const SWITCH_DOCK_TITLE = $r('app.string.MultiWindow_dock_switch_title');
const SWITCH_DOCK_CONTENTS = $r('app.string.MultiWindow_dock_switch_contents');
const SWITCH_TITLE_FONTSIZE = $r('sys.float.ohos_id_text_size_body1');
const SWITCH_TITLE_FONTCOLOR = $r('sys.color.ohos_id_color_text_primary');
const SWITCH_BACKGROUND_COLOR = $r('sys.color.ohos_id_color_card_bg');
const SWITCH_CONTENT_FONTSIZE = $r('sys.float.ohos_id_text_size_body2');
const SWITCH_CONTENT_FONTCOLOR = $r('sys.color.ohos_id_color_text_secondary');
const SWITCH_PIP_TITLE = $r('app.string.MultiWindow_pip_switch_title');
const SWITCH_PIP_CONTENTS = $r('app.string.MultiWindow_pip_switch_desc');

const uiType: string = sceneSessionManager.getWindowSceneConfig()?.uiType;

const PAD_LOTTIE_RATIO = 1920 / 1280;
const PIP_AUTO_START_KEY: string = 'auto_start_pip_status';
const MULTI_DOCK_STATUS: string = 'multi_dock_status';

@Observed
class MultiWindowSettingDataStruct {
  public mainCanvasRenderingContext: CanvasRenderingContext2D | null = null;
  public dataPath: string = '';
  public title: Resource | string = '';
  public content: Resource | string = '';

  constructor(mainRenderingSettings: RenderingContextSettings, datalist: string[]) {
    this.mainCanvasRenderingContext = new CanvasRenderingContext2D(mainRenderingSettings);
    this.dataPath = datalist[0];
    this.title = $r(datalist[1]);
    this.content = $r(datalist[2]);
  }
}

@Entry(storage)
@Component
export default struct MultiWindowSettingPage {
  @State sourceDataList: MultiWindowSettingDataStruct[] = [];
  @State multiDockSwitchState: boolean = false;
  @State pipSwitchState: boolean = true;
  private swiperController: SwiperController = new SwiperController();
  private mainRenderingSettings: RenderingContextSettings = new RenderingContextSettings(true)
  private lottieItems: AnimationItem[] = [];
  private isLargeFoldDevice: boolean = false;
  private lottieRatio = 1;
  private context: Context | undefined = AppStorage.get('multiWindowPageContext');
  @State pagePadding: number = 16;
  @State isShowBack: boolean = storage?.get<boolean>('isShowBack') ?? true;

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.destroyLottie();
    MultiDockSwitchController.getInstance().pageCnt++;
    this.initPiPSwitch();
    this.initMultiDockSwitch();
    this.initIsLargeFoldDeviceFlag();
    try {
      let retPiP: boolean = settings.registerKeyObserver(this.context, PIP_AUTO_START_KEY,
        settings.domainName.USER_PROPERTY, () => {
          let value: boolean = sSettingsUtil.getSystemValue(PIP_AUTO_START_KEY, 'true', this.context) === 'true';
          this.pipSwitchState = value;
        });
      let retDock: boolean = settings.registerKeyObserver(this.context, MULTI_DOCK_STATUS,
        settings.domainName.USER_PROPERTY, () => {
          let value: boolean = sSettingsUtil.getSystemValue(MULTI_DOCK_STATUS, 'true', this.context) === 'true';
          this.multiDockSwitchState = value;
        });
      log.showInfo(`registerMultiWindowSwitchObserver ret:value -> retPiP: ${String(retPiP)},
        retDock: ${String(retDock)}`);
    } catch (err) {
      let errInfo: BusinessError = err as BusinessError;
      log.showError(`registerMultiWindowSwitchObserver, catch err code: ${errInfo?.code} msg: ${errInfo?.message}`);
    }
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    MultiDockSwitchController.getInstance().pageCnt--;
    if (MultiDockSwitchController.getInstance().pageCnt === 0) {
      this.destroyLottie();
    }
    try {
      if (this.isLargeFoldDevice) {
        display.off('foldStatusChange', this.foldStatusChangeCallback);
      }
      let retPiP: boolean = settings.unregisterKeyObserver(this.context, PIP_AUTO_START_KEY,
        settings.domainName.USER_PROPERTY);
      let retDock: boolean = settings.unregisterKeyObserver(this.context, MULTI_DOCK_STATUS,
        settings.domainName.USER_PROPERTY);
      AppStorage.delete('multiWindowPageContext');
      log.showInfo(`unRegisterMultiWindowSwitchObserver ret:value -> retPiP: ${String(retPiP)},
        retDock: ${String(retDock)}`);
    } catch (err) {
      let errInfo: BusinessError = err as BusinessError;
      log.showError(`unRegisterMultiWindowSwitchObserver, catch err code: ${errInfo?.code} msg: ${errInfo?.message}`);
    }
  }

  private foldStatusChangeCallback: () => void = () => {
    this.initSourceData();
  };

  private initMultiDockSwitch() {
    this.multiDockSwitchState = MultiDockSwitchController.getForAll(this.context);
    log.showInfo(`multi dock switch state is ${this.multiDockSwitchState}`);
  }

  private initPiPSwitch() {
    this.pipSwitchState = PiPSwitchController.getForAll(this.context);
    log.showInfo(`init pip switch state is ${this.pipSwitchState}`);
  }

  private initSourceData() {
    let lottiePathList: string[][] = [];

    if (uiType === SCBConstants.UITYPE_PAD) {
      lottiePathList = [CHANGE_VIEWS_PAD, FLOATING_WINDOWS_PAD, DOCK_PAD, SPLIT_SCREEN_PAD];
      this.pagePadding = 24;
      this.lottieRatio = PAD_LOTTIE_RATIO;
    } else if (this.isLargeFoldDevice && this.getFoldStatus() !== display.FoldStatus.FOLD_STATUS_FOLDED) {
      lottiePathList = [CHANGE_VIEWS_FOLD, FLOATING_WINDOWS_FOLD, DOCK_FOLD, SPLIT_SCREEN_FOLD];
      this.isShowBack = storage?.get<boolean>('isShowBack') ?? true;
    } else {
      lottiePathList = [CHANGE_VIEWS_PHONE, FLOATING_WINDOWS_PHONE, DOCK_PHONE, SPLIT_SCREEN_PHONE];
      this.isShowBack = true;
    }

    for (let i = 0; i < lottiePathList.length; i++) {
      let index = this.sourceDataList[i]
      if (index) {
        index.dataPath = lottiePathList[i][0];
      } else {
        this.sourceDataList.push(new MultiWindowSettingDataStruct(this.mainRenderingSettings, lottiePathList[i]))
      }
    }
    this.sourceDataList.length = lottiePathList.length;

    let tempElement = this.sourceDataList.pop();
    if (tempElement) {
      this.sourceDataList.push(tempElement);
    }
  }

  private getFoldStatus(): display.FoldStatus {
    try {
      return display.getFoldStatus();
    } catch (e) {
      log.showError(`getFoldStatus error: ${e}`);
    }
    return display.FoldStatus.FOLD_STATUS_UNKNOWN;
  }

  async initIsLargeFoldDeviceFlag(): Promise<void> {
    try {
      const foldScreenFlag = await systemParameterEnhance.get('const.window.foldscreen.type', '0,0,0,0');
      if (foldScreenFlag === '' || foldScreenFlag === null) {
        this.isLargeFoldDevice = false;
      }
      this.isLargeFoldDevice = foldScreenFlag.substring(0, 1) === '1';
    } catch (error) {
      log.showError(`foldScreenFlag init  error: ${error}`);
    }
    this.initSourceData();
    if (this.isLargeFoldDevice) {
      try {
        display.on('foldStatusChange', this.foldStatusChangeCallback);
      } catch (e) {
        log.showError(`display register foldStatusChangeCallback error: ${e}`);
      }
    }
  }

  private destroyLottie() {
    log.showInfo('destroyLottie');
    let destroyLottieList = [CHANGE_VIEWS_PAD[0], FLOATING_WINDOWS_PAD[0],
      DOCK_PAD[0], SPLIT_SCREEN_PAD[0], MID_VIEW_PAD[0]];
    for (let i = 0; i < destroyLottieList.length; i++) {
      lottie.destroy(destroyLottieList[i])
    }
  }

  build() {
    Column() {
      this.title();
      Scroll() {
        Column() {
          this.guide();
          this.dockSwitch();
          this.pipSwitch();
        }
      }
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.Top)
      .width('100%')
      .layoutWeight(1);
    }
    .padding({ left: this.pagePadding, right: this.pagePadding })
    .backgroundColor(PAGE_BACKGROUND_COLOR)
  }

  // title
  @Builder
  title() {
    Row() {
      if (this.isShowBack) {
        Button() {
          Image(TITLE_BAR_BACK_IMG)
            .width(24)
            .height(24)
            .fillColor(TITLE_BAR_FILL_COLOR)
            .draggable(false)
            .matchTextDirection(true)
            .accessibilityText(getContext(this).resourceManager.getStringSync($r('app.string.Ai_bar_back').id))
        }
        .width(40)
        .height(40)
        .backgroundColor(TITLE_BAR_GROUND_COLOR)
        .onClick(() => {
          try {
            storage?.get<UIExtensionContentSession>('session')?.sendData({ 'action': 'pop' })
          } catch (error) {
            log.showError(`try back error, ${error}`);
          }
        })

        Blank().width(8).visibility(Visibility.Hidden);
      }
      Text(MULTI_WINDOW_TITLE)
        .fontSize(MULTI_WINDOW_TITLE_FONTSIZE)
        .fontColor(MULTI_WINDOW_TITLE_FONTCOLOR)
        .fontWeight(FontWeight.Bold)
        .wordBreak(WordBreak.BREAK_WORD)
        .fontFamily('HarmonyHeiTi')
    }
    .width('100%')
    .height(56)
  }

  @Builder
  guide() {
    Swiper(this.swiperController) {
      ForEach(this.sourceDataList, (item: MultiWindowSettingDataStruct, index: number) => {
        Column() {
          Canvas(item.mainCanvasRenderingContext)
            .height(300)
            .width(300 * this.lottieRatio)
            .onReady(() => {
              log.showInfo('lottie onReady index: ' + index);
              lottie.destroy(item.dataPath);
              this.lottieItems[index]?.resize();
              this.lottieItems[index] = lottie.loadAnimation({
                container: item.mainCanvasRenderingContext,
                renderer: 'canvas',
                loop: true,
                autoplay: true,
                name: item.dataPath,
                frameRate: 40,
                contentMode: 'Contain',
                path: item.dataPath,
              })
            })
            .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
              log.showInfo('Canvas is visible, play lottie, index: ' + index);
              this.lottieItems[index]?.play();
              if (!isVisible && currentRatio <= 0.0) {
                log.showInfo('Canvas is completely invisible, pause lottie, index: ' + index);
                this.lottieItems[index]?.pause();
              }
            })

          Text(item.title)
            .fontSize(SWIPER_TITLE_FONTSIZE)
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi')
            .textAlign(TextAlign.Center)
            .margin({ top: 8 })

          Text(item.content)
            .fontSize(SWIPER_CONTENT_FONTSIZE)
            .fontColor(SWIPER_CONTENT_FONTCOLOR)
            .fontWeight(FontWeight.Regular)
            .fontFamily('HarmonyHeiTi')
            .textAlign(TextAlign.Center)
            .margin({ top: 8, bottom: 40 })
        }.width('100%')
      }, (item: MultiWindowSettingDataStruct) => item.dataPath)
    }.cachedCount(1)
    .indicator(Indicator.dot())
    .curve(Curve.Linear)
    .loop(false)
  }

  @Builder
  dockSwitch() {
    Column() {
      Row() {
        Text(SWITCH_DOCK_TITLE)
          .fontSize(SWITCH_TITLE_FONTSIZE)
          .fontColor(SWITCH_TITLE_FONTCOLOR)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
        Toggle({ type: ToggleType.Switch, isOn: this.multiDockSwitchState })
          .onChange((isOn: boolean) => {
            MultiDockSwitchController.setForAll(this.context, isOn);
            log.showInfo(`multiDockSwitchState change: ${isOn}`);
          })
          .hoverEffect(HoverEffect.None)
      }
      .padding({
        left: 12,
        right: 12,
        top: 14,
        bottom: 14
      })
      .margin({ bottom: 8 })
      .backgroundColor(SWITCH_BACKGROUND_COLOR)
      .borderRadius(16)
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Text(SWITCH_DOCK_CONTENTS)
          .fontSize(SWITCH_CONTENT_FONTSIZE)
          .fontColor(SWITCH_CONTENT_FONTCOLOR)
          .fontWeight(FontWeight.Regular)
          .fontFamily('HarmonyHeiTi')
      }
      .width('100%')
      .padding({ left: 12, right: 12 })
      .margin({ bottom: 16 })
    }
  }

  @Builder
  pipSwitch() {
    Column() {
      Row() {
        Text(SWITCH_PIP_TITLE)
          .fontSize(SWITCH_TITLE_FONTSIZE)
          .fontColor(SWITCH_TITLE_FONTCOLOR)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
        Toggle({ type: ToggleType.Switch, isOn: this.pipSwitchState })
          .onChange((isOn: boolean) => {
            PiPSwitchController.setForAll(this.context, isOn);
            log.showInfo(`pipSwitchState change: ${isOn}`);
          })
          .hoverEffect(HoverEffect.None)
      }
      .padding({
        left: 12,
        right: 12,
        top: 14,
        bottom: 14
      })
      .margin({ bottom: 8 })
      .backgroundColor(SWITCH_BACKGROUND_COLOR)
      .borderRadius(16)
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Row() {
        Text(SWITCH_PIP_CONTENTS)
          .fontSize(SWITCH_CONTENT_FONTSIZE)
          .fontColor(SWITCH_CONTENT_FONTCOLOR)
          .fontWeight(FontWeight.Regular)
          .fontFamily('HarmonyHeiTi')
      }
      .width('100%')
      .padding({ left: 12, right: 12 })
      .margin({ bottom: 16 })
    }
  }
}