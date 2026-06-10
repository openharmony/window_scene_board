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

import { CardItemInfo, FormCommonUtil } from '@ohos/launchercommon';
import { LockscreenFormConfig } from '../common/WidgetParam';
import {
  ISlState,
  SlBindStateType,
} from '@ohos/screenlockcommon';
import {
  aodHardwareConfig,
  EDIT_GUIDE_MODE,
  NONE_EDIT_MODE
} from '@ohos/screenlockcommon/Index';
import lazy OuterScreenLockFormViewModel from './vm/OuterScreenLockFormViewModel';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { FormComponentBuilder } from './vm/FormComponentBuilder';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import curves from '@ohos.curves';
import { SlWidgetId } from '@ohos/screenlockcommon/src/main/ets/constants/SlWidgetConst';
import { LengthMetrics } from '@ohos.arkui.node';
import WidgetConstants from '../common/Constants';
import Constants from './common/Constants';
import { slStateHelper } from '../common/utils/SlStateHelper';
import { ScreenLockSpaceAniData, spaceAniHelper, WidgetAnimState } from '@ohos/screenlockcommon/Index';
import lazy { SlOuterFormBindState } from '../clock/model/data/SlOuterFormBindState';
import lazy { SlOuterFormStaticState } from '../clock/model/data/SlOuterFormStaticState';

const TAG = 'OuterScreenLockFormPanel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const SINGLE_COLOR_RENDER_MODE: number = 1;
const COMPONENT_ID_SCREEN_LOCK_FORM = SlWidgetId.FORM;
const FORM_ICON_FACTOR = 1.2;
const FORM_ICON_SCALE = 0.8;
const BLEND_MODE_SRC_IN = 6;
const FORM_TOUCH_DOWN_SCALE = 0.95;

@Component
export default struct OuterScreenLockFormPanel {
  @Prop clockStrokeColor?: string = '';
  @Prop isLightWallpaper: boolean = false;
  @Prop isAod: boolean = false;
  @Link outerFormViewModel: OuterScreenLockFormViewModel;
  @Link displayMode: number;
  @StorageProp('isClearInvalidCardsDone') isClearInvalidCardsDone: boolean = false;
  @State slBindState?: ISlState = slStateHelper.getSlBindState();
  @State spaceAniOpt: ScreenLockSpaceAniData = spaceAniHelper.getSpaceAniFormState();

  @State slOuterFormAnimCtrl: WidgetAnimState | undefined =
    slStateHelper.getSlOuterFormAnimState(); // 小外屏服务卡片动效状态管理
  @State slOuterFormBindCtrl: SlOuterFormBindState | undefined =
    slStateHelper.getSlOuterFormBindState(); // 小外屏服务卡片UI样式状态管理
  @State slOuterFormStaticCtrl: SlOuterFormStaticState | undefined =
    slStateHelper.getSlOuterFormStaticState(); // 小外屏服务卡片静态状态管理

  aboutToAppear() {
    log.showDebug('aboutToAppear');
  }

  aboutToDisappear() {
    log.showDebug('aboutToDisappear');
  }

  // 小外屏服务卡片缩放
  private getScale(): ScaleOptions {
    let zoomRatio = this.slBindState?.getSlState(SlBindStateType.SL_ZOOM_RATIO);
    if (zoomRatio && zoomRatio > Constants.DEFAULT_ZOOM_RATIO) {
      return {
        x: this.spaceAniOpt.getSpaceScale(),
        y: this.spaceAniOpt.getSpaceScale(),
        centerX: '50%',
        centerY: '50%'
      };
    }
    if (this.slOuterFormAnimCtrl?.isSceneAnimating()) {
      return {
        x: this.slOuterFormAnimCtrl.getScaleX() ?? 1,
        y: this.slOuterFormAnimCtrl.getScaleY() ?? 1
      };
    }
    return {
      x: this.slOuterFormBindCtrl?.getLayoutScale() ?? 1,
      y: this.slOuterFormBindCtrl?.getLayoutScale() ?? 1
    };
  }

  build() {
    Column() {
      Stack() {
        if (this.isClearInvalidCardsDone && this.outerFormViewModel.getOuterFormLen()) {
          Stack() {
            OuterScreenLockFormComponent({
              outerFormViewModel: this.outerFormViewModel,
              isAod: this.isAod,
              isLightWallpaper: this.isLightWallpaper,
              clockStrokeColor: this.clockStrokeColor,
              displayMode: this.displayMode
            })
          }
          .accessibilityLevel('no')
          .hitTestBehavior(HitTestMode.Transparent)

          Stack() {
          }
          .width('100%')
          .height('100%')
          .opacity(0)
          .hitTestBehavior(HitTestMode.None)
          .id(SlWidgetId.FORM_FOR_AOD)
        }
      }
    }
    .scale(this.getScale())
    .width(Constants.OUTER_PANEL_WIDTH)
    .height(Constants.OUTER_SCREEN_FORM_COMPONENT_HEIGHT)
    .position({ start: LengthMetrics.vp(0) })
    .alignItems(HorizontalAlign.Start)
    .accessibilityLevel('no')
    .hitTestBehavior(this.displayMode === NONE_EDIT_MODE ? HitTestMode.Transparent : HitTestMode.Block)
    .id(COMPONENT_ID_SCREEN_LOCK_FORM)
  }
}

class GridLayoutOptionRect {
  public static getGridLayoutOptions(outerFormViewModel: OuterScreenLockFormViewModel): GridLayoutOptions {
    return {
      onGetRectByIndex: (index: number): [number, number, number, number] => {
        // 检查索引在有效范围内
        if (index < 0 || index >= outerFormViewModel.formConfigs.length) {
          return [-1, 1, -1, 1];
        }
        let config: LockscreenFormConfig | undefined = outerFormViewModel.formConfigs[index];
        if (!config) {
          return [-1, 1, -1, 1];
        }
        let rect: [number, number, number, number] = GridLayoutOptionRect.getFormItemRect(config);
        return rect;
      },
      regularSize: [1, 1]
    };
  }

  private static getFormItemRect(config: LockscreenFormConfig): [number, number, number, number] {
    log.showInfo(`getFormItemRect, positionX: ${config.positionX - 1}, dimensionX: ${config.dimensionX}`);
    return [0, config.positionX - 1, 1, config.dimensionX];
  }
}

@Component
struct OuterScreenLockFormComponent {
  @Prop isAod: boolean;
  @Prop clockStrokeColor?: string = '';
  @Prop isLightWallpaper: boolean = false;
  @Link @Watch('onFormConfigChange') outerFormViewModel: OuterScreenLockFormViewModel;
  @Link @Watch('onDisplayModeChange') displayMode: number;
  @State layoutOptions: GridLayoutOptions = GridLayoutOptionRect.getGridLayoutOptions(this.outerFormViewModel);
  @State outerFormComponentOpacity: number = 1;

  aboutToAppear() {
    log.showInfo('OuterScreenLockFormComponent aboutToAppear');
  }

  aboutToDisappear() {
    log.showInfo('OuterScreenLockFormComponent aboutToDisappear');
  }

  private onDisplayModeChange(): void {
    if (this.displayMode === EDIT_GUIDE_MODE) {
      animateTo({
        duration: Constants.OUTER_SCREEN_CARD_OPACITY_DURATION,
        curve: Curve.Linear,
      }, () => {
        this.outerFormComponentOpacity = 0;
      })
    }
    if (this.displayMode === NONE_EDIT_MODE) {
      animateTo({
        duration: Constants.OUTER_SCREEN_CARD_OPACITY_DURATION,
        curve: Curve.Linear,
        delay: Constants.OUTER_SCREEN_CARD_OPACITY_DELAY,
      }, () => {
        this.outerFormComponentOpacity = 1;
      })
    }
  }

  private onFormConfigChange(): void {
    // 触发网格刷新
    log.showInfo('onFormConfigChange');
    this.layoutOptions = GridLayoutOptionRect.getGridLayoutOptions(this.outerFormViewModel);
  }

  private getForEachKey(item: LockscreenFormConfig): string {
    return `${item.dimensionX}_${item.formInfo?.bundleName}_${item.formInfo?.cardName}_${item.formInfo?.tempId}`;
  }

  private getFormIndex(form: LockscreenFormConfig): number {
    let newIndex: number = -1;
    let sourceKey: string = this.getForEachKey(form);
    this.outerFormViewModel.formConfigs.forEach((item, index) => {
      if (this.getForEachKey(item) === sourceKey) {
        newIndex = index;
        return;
      }
    })
    return newIndex;
  }

  private getTransitionEffect(): TransitionEffect {
    return TransitionEffect.OPACITY.animation({
      duration: Constants.OUTER_SCREEN_CARD_OPACITY_DURATION,
      curve: Curve.Linear
    })

  }

  build() {
    Grid(undefined, this.layoutOptions) {
      ForEach(this.outerFormViewModel.formConfigs, (item: LockscreenFormConfig, index: number) => {
        if (item.dimensionX !== 0) {
          GridItem() {
            OuterScreenLockFormCard({
              index: this.getFormIndex(item),
              formWidth: Constants.OUTER_SCREEN_SINGLE_CARD_SIZE * item.dimensionX +
                Constants.OUTER_SCREEN_GRID_GAP * (item.dimensionX - 1),
              cardInfo: item.formInfo,
              outerFormViewModel: this.outerFormViewModel,
              radius: Constants.OUTER_SCREEN_FORM_COMPONENT_RADIUS,
              onAcquiredFailedCallback: () => {
                this.outerFormViewModel.deleteScreenLockForm(item);
              },
              isAod: this.isAod,
              isLightWallpaper: this.isLightWallpaper,
              clockStrokeColor: this.clockStrokeColor,
              displayMode: this.displayMode
            })
              .opacity(this.outerFormViewModel.formComponentOpacity)
              .width((Constants.OUTER_SCREEN_SINGLE_CARD_SIZE * item.dimensionX +
                Constants.OUTER_SCREEN_GRID_GAP * (item.dimensionX - 1)))
              .height(Constants.OUTER_SCREEN_SINGLE_CARD_SIZE)
              .accessibilityLevel('no')
          }
        }
      }, (item: LockscreenFormConfig, index: number) => this.getForEachKey(item))
    }
    .columnsGap(Constants.OUTER_SCREEN_GRID_GAP)
    .padding({
      top: Constants.OUTER_SCREEN_GRID_PADDING_HEIGHT, bottom: Constants.OUTER_SCREEN_GRID_PADDING_HEIGHT,
      left: Constants.OUTER_SCREEN_GRID_PADDING_WIDTH, right: Constants.OUTER_SCREEN_GRID_PADDING_WIDTH
    })
    .columnsTemplate('1fr 1fr')
    .rowsTemplate('1fr')
    .width(Constants.OUTER_PANEL_WIDTH)
    .height(Constants.OUTER_SCREEN_GRID_HEIGHT)
    .opacity(this.outerFormComponentOpacity)
    .transition(this.getTransitionEffect())
  }
}

@Component
struct OuterScreenLockFormCard {
  @Prop index: number;
  @Prop radius: number;
  @Prop cardInfo: CardItemInfo;
  @Prop formWidth: number;
  @Link outerFormViewModel: OuterScreenLockFormViewModel;
  @Link displayMode: number;
  @Prop isAod: boolean;
  @Prop clockStrokeColor?: string = '';
  @Prop isLightWallpaper: boolean = false;
  @State formScale: number = 1;

  private keyguardCardDarkBgOption: BackgroundBrightnessOptions = BrightnessOptionUtils.keyguardCardBackgroundDarkOption;
  private keyguardCardLightBgOption: BackgroundBrightnessOptions = BrightnessOptionUtils.keyguardCardBackgroundLightOption;
  private keyguardTimeDarkOption: BackgroundBrightnessOptions = BrightnessOptionUtils.keyguardTimeDarkOption;
  private keyguardTimeLightOption: BackgroundBrightnessOptions = BrightnessOptionUtils.keyguardTimeLightOption;
  private aodFormBackboardLightOption: BackgroundBrightnessOptions = BrightnessOptionUtils.aodFormBackboardLightOption;
  private brightColor: ResourceColor = BrightnessOptionUtils.brightColor;
  private currentFormId: string = '';
  private onAcquiredFailedCallback: Function = (): void => {
  };
  private formComponentBuilder: FormComponentBuilder = {
    id: FormCommonUtil.transformCardId(this.cardInfo.cardId),
    name: this.cardInfo.cardName,
    bundle: this.cardInfo.bundleName,
    ability: this.cardInfo.abilityName,
    module: this.cardInfo.moduleName,
    dimension: this.cardInfo.cardDimension,
    renderingMode: SINGLE_COLOR_RENDER_MODE,
    want: OuterScreenLockFormViewModel.getFromWant(),
  };

  aboutToAppear() {
    log.showInfo(`OuterScreenLockFormCard aboutToAppear, formId: ${this.cardInfo.cardId}`);
  }

  aboutToDisappear() {
    log.showInfo(`OuterScreenLockFormCard aboutToDisappear, currentFormId: ${this.currentFormId}`);
  }

  private getBackgroundColor(): ResourceColor | undefined {
    return BrightnessOptionUtils.changeColor(this.clockStrokeColor) ?? this.brightColor;
  }


  private getBrightnessOption(): BackgroundBrightnessOptions {
    if (this.clockStrokeColor !== WidgetConstants.CLOCK_DEFAULT_FOREGROUND_COLOR) {
      return this.isLightWallpaper ?
      BrightnessOptionUtils.keyguardTimeDarkOptionForFillColor :
      BrightnessOptionUtils.keyguardTimeLightOptionForFillColor;
    }
    return this.isLightWallpaper ? this.keyguardTimeDarkOption : this.keyguardTimeLightOption;
  }

  // private getAodBrightnessOption(): BrightnessOptions {
  //   if (this.clockStrokeColor !== WidgetConstants.CLOCK_DEFAULT_FOREGROUND_COLOR) {
  //     return this.isLightWallpaper ?
  //       BrightnessOptionUtils.aodFormFrontColorationDarkOption :
  //       return BrightnessOptionUtils.aodFormFrontLightOption;
  //   }

  private getAodBrightnessOption(): BackgroundBrightnessOptions {
    if (this.clockStrokeColor !== WidgetConstants.CLOCK_DEFAULT_FOREGROUND_COLOR) {
      return this.isLightWallpaper ?
      BrightnessOptionUtils.aodFormFrontColorationDarkOption :
      BrightnessOptionUtils.aodFormFrontColorationLightOption;
    }
    return BrightnessOptionUtils.aodFormFrontLightOption;
  }

  // private getBgBrightnessOption(): BrightnessOptions  | undefined {
  //   return this.isLightWallpaper ? this.keyguardCardDarkBgOption : this.keyguardCardLightBgOption;
  // }

  private getBgBrightnessOption(): BackgroundBrightnessOptions | undefined {
    return this.isLightWallpaper ? this.keyguardCardDarkBgOption : this.keyguardCardLightBgOption;
  }

  build() {
    Stack() {
      Stack() {
        Stack() {
          Column() {
          }
          .width('100%')
          .height('100%')
          .borderRadius(this.radius)
          .useEffect(true)
          .visibility(this.displayMode === NONE_EDIT_MODE ? Visibility.Visible : Visibility.Hidden)

          Column() {
          }
          .width('100%')
          .height('100%')
          .backgroundColor(this.brightColor)
          .backgroundBrightness(this.getBgBrightnessOption())
          .borderRadius(this.radius)
        }
        .hitTestBehavior(HitTestMode.Transparent)
      }
      .accessibilityLevel('no-hide-descendants')
      .margin({
        top: LengthMetrics.vp(0),
        bottom: LengthMetrics.vp(0),
        start: LengthMetrics.vp(0),
        end: LengthMetrics.vp(0)
      })
      .borderRadius(this.radius)

      Stack({ alignContent: Alignment.TopEnd }) {
        Stack() {
          FormComponent(this.formComponentBuilder)
            .width(this.formWidth * FORM_ICON_FACTOR)
            .height(Constants.OUTER_SCREEN_SINGLE_CARD_SIZE * FORM_ICON_FACTOR)
            .scale({
              x: FORM_ICON_SCALE,
              y: FORM_ICON_SCALE
            })
            .borderRadius(this.radius)
            .onAcquired((form: FormCallbackInfo) => {
              log.showInfo(`FormComponent card id is: ${form?.idString}`);
              this.currentFormId = String(form?.idString);
              this.outerFormViewModel.updateFormId(this.index, this.currentFormId);
              this.outerFormViewModel.registerRouterProxy(String(form?.idString));
            })
            .onError((error) => {
              log.showInfo(`FormComponent error msg: ${error.msg}, currentFormId: ${this.currentFormId}`);
              this.onAcquiredFailedCallback();
            })
            .onUninstall((id: FormCallbackInfo) => {
              log.showInfo(`FormComponent uninstall: ${id}`);
              this.onAcquiredFailedCallback();
            })
            .onLoad(() => {
              log.showInfo(`onLoad success, currentFormId: ${this.currentFormId}`);
            })
            .accessibilityLevel('no')
        }
        .hitTestBehavior(HitTestMode.Transparent)
        .margin({ top: LengthMetrics.vp(0), end: LengthMetrics.vp(0)})
        .id(`${TAG}_${this.index}`)
        .size({
          height: '100%',
          width: '100%'
        })
        .scale({
          x: this.formScale,
          y: this.formScale
        })
        .onTouch((event: TouchEvent) => {
          if (event.type === TouchType.Down) {
            animateTo({
              curve: curves.interpolatingSpring(0, 0, 240, 28),
            }, () => {
              this.formScale = FORM_TOUCH_DOWN_SCALE;
            })
          } else if (event.type === TouchType.Up) {
            animateTo({
              curve: curves.interpolatingSpring(0, 0, 240, 28),
            }, () => {
              this.formScale = 1;
            })
          }
        })
        .accessibilityText(this.cardInfo.appName)
        .accessibilityLevel('yes')

        Column() {
        }
        .hitTestBehavior(HitTestMode.Transparent)
        .width('100%')
        .height('100%')
        .blendMode(BLEND_MODE_SRC_IN)
        .accessibilityLevel('no')

        Column() {
        }
        .hitTestBehavior(HitTestMode.Transparent)
        .width('100%')
        .height('100%')
        .backgroundColor(this.getBackgroundColor())
        .backgroundBrightness(this.getBrightnessOption())
        .accessibilityLevel('no')

        if (this.clockStrokeColor !== WidgetConstants.CLOCK_DEFAULT_FOREGROUND_COLOR) {
          Column() {
          }
          .hitTestBehavior(HitTestMode.Transparent)
          .width('100%')
          .height('100%')
          .backgroundColor(this.getBackgroundColor())
          // .backgroundBrightnessInternal(BrightnessOptionUtils.keyguardSecondBrightnessOption)
          .backgroundBrightness(BrightnessOptionUtils.keyguardSecondBrightnessOption)
          .accessibilityLevel('no')
        }
      }
      .blendMode(1000)
    }
    .accessibilityLevel('no')
  }
}