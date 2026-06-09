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

import { StyleConstants, CardItemInfo, } from '@ohos/launchercommon';
import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';
import { commonBundleManager, ResourceManager } from '@ohos/frameworkwrapper';
import Curves from '@ohos.curves';
import { ScreenLockFormManagerUtil } from '@ohos/screenlockcommon';
import { FormComponentBuilder } from './vm/FormComponentBuilder';
import ScreenLockFormViewModel from './vm/ScreenLockFormViewModel';
import { baseStateMgr, DarkModeState, StateType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import AnimationUtil from '../editsheet/utils/AnimationUtil';
import { DynamicFontSize, sFontScaleUtil } from '../common/utils/FontScaleUtil';
import Constants from './common/Constants';

const TAG = 'ServiceFormItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const SINGLE_COLOR_RENDER_MODE:number = 1;

const FORM_BACKGROUND_LIGHT: BrightnessOptions = {
  rate: 1,
  lightUpDegree: -55 / 255,
  cubicCoeff: 0,
  quadCoeff: 0,
  fraction: 0,
  saturation: 2,
  negRGB: [2.3, 4.5, 2],
  posRGB: [0.5, 2, 0.5],
}

const FORM_BACKGROUND_DARK: BrightnessOptions = {
  rate: 1,
  lightUpDegree: -15 / 255,
  cubicCoeff: 0,
  quadCoeff: 0,
  fraction: 0,
  saturation: 2,
  negRGB: [2.3, 4.5, 2],
  posRGB: [0.5, 2, 0.5],
}

@Component
export default struct ScreenLockFormItem {
  @State showFormName: boolean = true;
  @State isAllowUpdate: boolean = true;
  @State isHover: boolean = false;
  @State mFormItemWidth: number = 0;
  @State mFormItemHeight: number = 0;
  @State iconScale: number = 1;
  @State iconOpacity: number = 1;
  @State darkModeState: DarkModeState = baseStateMgr.getBaseState(StateType.TYPE_DARK_MODE) as DarkModeState;
  @State animateParam: AnimateParam = {
    duration: 200,
    tempo: 1,
    curve: Curves.springCurve(0.5, 1, 350, 35)
  };
  @State opacityValue: number = 1;
  @State animateScale: number = 1;
  @State formComponentOpacity: number = 0;
  private idIndex: number = 0;
  private formItem: CardItemInfo = new CardItemInfo();
  private formId: string = '';
  getFormId: Function = (id: number): void => {
  };
  private formComponentBuilder: FormComponentBuilder = {
    id: 0,
    name: '',
    bundle: '',
    ability: '',
    module: '',
    dimension: 0,
    renderingMode:SINGLE_COLOR_RENDER_MODE,
    want:{}
  };

  public aboutToAppear(): void {
    this.formComponentBuilder = {
      id: 0,
      name: this.formItem.cardName as string,
      bundle: this.formItem.bundleName as string,
      ability: this.formItem.abilityName as string,
      module: this.formItem.moduleName as string,
      dimension: this.formItem.cardDimension as number,
      renderingMode:SINGLE_COLOR_RENDER_MODE,
      want:ScreenLockFormViewModel.getFromWant(),
    };
    log.showInfo(`aboutToAppear, bundlename=${this.formItem.bundleName}`);
  }

  public aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear, bundlename=${this.formItem.bundleName}`);
    if (!CheckEmptyUtils.checkStrIsEmpty(this.formId)) {
      ScreenLockFormManagerUtil.deleteFormById(this.formId);
    }
  }

  private playTouchAnimation(isPress: boolean): void {
    log.showInfo(`playTouchAnimation ${isPress}`);
    if (isPress) {
      let curve: Curves.ICurve = ScreenLockFormItem.getPressAnimateCurve(this.formItem.cardDimension);
      let scale: number = ScreenLockFormItem.getPressAnimateScale(this.formItem.cardDimension);
      animateTo({
        delay: 100,
        curve: curve,
      }, () => {
        this.animateScale = scale;
      })
    } else {
      animateTo({
        delay: 100,
        duration: 250,
        curve: Curve.Friction,
      }, () => {
        this.animateScale = 1;
      })
    }
  }

  /**
   * Get form Curve options.
   *
   * @param dimension card dimension
   * @returns Curve
   */
  private static getPressAnimateCurve(dimension: number): Curves.ICurve {
    let curve: Curves.ICurve;
    switch (dimension) {
      case FormDimension.Dimension_1_2:
      case FormDimension.Dimension_2_1:
        curve = Curves.interpolatingSpring(1, 1, 410, 38);
        break;
      case FormDimension.Dimension_2_2:
      case FormDimension.Dimension_2_4:
        curve = Curves.interpolatingSpring(0.5, 1, 350, 35);
        break;
      case FormDimension.Dimension_4_4:
      default:
        curve = Curves.interpolatingSpring(0, 1, 240, 28);
        break;
    }
    return curve;
  }

  /**
   * Get form scale options.
   *
   * @param dimension card dimension
   * @returns scaleOptions
   */
  public static getPressAnimateScale(dimension: number): number {
    let scale: number;
    switch (dimension) {
      case FormDimension.Dimension_1_2:
      case FormDimension.Dimension_2_1:
        scale = Constants.FORM_MANAGER_PANEL_SCALE_90;
        break;
      case FormDimension.Dimension_2_2:
      case FormDimension.Dimension_2_4:
      case FormDimension.Dimension_4_4:
      default:
        scale = Constants.FORM_MANAGER_PANEL_SCALE_95;
        break;
    }
    return scale;
  }

  private playLongPressAnimation(): void {
    log.showInfo('playLongPressAnimation');
    animateTo({
      duration: 250,
      curve: Curve.Friction,
    }, () => {
      this.animateScale = 1;
    })
  }

  @Builder
  formItemBuilder() {
    Stack() {
      Column()
        .backgroundColor('#FF0000')
        .backgroundBrightnessInternal(this.darkModeState?.isDarkMode ? FORM_BACKGROUND_DARK : FORM_BACKGROUND_LIGHT)
        .borderRadius(this.mFormItemHeight / 2)
        .width(this.mFormItemWidth)
        .height(this.mFormItemHeight)
      Column() {
        FormComponent(this.formComponentBuilder)
          .id(`${TAG}_FormComponent_${this.idIndex}_${this.formItem.bundleName}`)
          .hoverEffect(HoverEffect.None)
          .borderRadius(this.mFormItemHeight / 2)
          .width(this.mFormItemWidth - 12)
          .height(this.mFormItemHeight - 12)
          .allowUpdate(this.isAllowUpdate)
          .opacity(this.formComponentOpacity)
          .onAcquired((form: FormCallbackInfo) => {
            log.showInfo(`FormComponent onAcquired formId=${form.idString}`);
            (this.formItem as CardItemInfo).cardId = String(form.idString);
            this.formId = String(form.idString);
            if (this.getFormId) {
              this.getFormId(form.idString);
            }
          })
          .onError((error) => {
            log.showInfo(`FormComponent onError msg: ${error.msg}`);
          })
          .onLoad(() => {
            log.showInfo(`FormComponent onLoad bundleName=%{public}s, cardId=%{public}s, ${this.formItem.bundleName}, ${this.formItem.cardId}`);
            AnimationUtil.createAnimateTo(Curve.Linear, 0, 200, () => {
              this.formComponentOpacity = 1;
            })
          })
          .accessibilityLevel('yes')
      }
      .padding({ top: 6, bottom: 6, left: 6, right: 6 })
      .width(this.mFormItemWidth)
      .height(this.mFormItemHeight)

      Column()
        .backgroundColor(Color.White)
        .opacity(0)
        .borderRadius(this.mFormItemHeight / 2)
        .width(this.mFormItemWidth)
        .height(this.mFormItemHeight)
    }
    .scale({ x: this.iconScale, y: this.iconScale })
    .opacity(this.iconOpacity)
    .animation(this.animateParam)
    .bindContextMenu(() => {}, ResponseType.LongPress)
  }

  build() {
    Column() {
      // 实现三层阴影效果
      Column() {
        this.formItemBuilder()
      }
      .borderRadius(this.mFormItemHeight / 2)
      .onTouch((event?: TouchEvent) => {
        if (event?.type === TouchType.Down) {
          this.playTouchAnimation(true);
        } else if (event?.type === TouchType.Up) {
          this.playTouchAnimation(false);
        }
      })
      .scale({ x: this.animateScale, y: this.animateScale })
      .opacity(this.iconOpacity)
      .parallelGesture(
        LongPressGesture({ repeat: false, duration: 550 })
          .onAction(() => {
            this.playLongPressAnimation();
          })
      )

      Column() {
        ServiceFormName({
          bundleName: this.formItem.bundleName,
          moduleName: this.formItem.moduleName,
          labelId: this.formItem.appLabelId,
          appName: this.formItem.appName,
          formNum: this.formItem.totleDimensionCount,
          idIndex: this.idIndex
        })
          .id(`${TAG}_AppName_${this.idIndex}_${this.formItem.bundleName}`)
      }
      .visibility(this.showFormName ? Visibility.Visible : Visibility.Hidden)
    }
    .onHover((isHover?: boolean) => {
      log.showInfo(`onHover isHover=${isHover}`);
      this.isHover = isHover as boolean;
    })
    .onDisAppear(() => {
      log.showInfo(`onDisAppear formId=${this.formId}`);
    })
  }
}

@Component
struct ServiceFormName {
  bundleName: string = '';
  moduleName: string = '';
  labelId: number = 0;
  @State @Watch('updateName') appName: string = '';
  @State fontScale: DynamicFontSize = sFontScaleUtil.realDynamicSize;
  formNum: number = 0;
  useCache: boolean = true;
  private mResourceManager: ResourceManager = ResourceManager.getInstance();
  private idIndex: number = 0;

  public aboutToAppear(): void {
    this.mResourceManager = ResourceManager.getInstance();
    this.updateName();
    if (CheckEmptyUtils.isEmpty(this.appName)) {
      this.updateApplicationLabelIdAndName();
    }
  }

  public appNameLoadCallback(name: string) {
    this.appName = name;
  }

  public updateName() {
    if (CheckEmptyUtils.isEmpty(this.appName)) {
      this.mResourceManager.getAppNameWithCache(this.labelId, this.bundleName, this.moduleName,
        this.appName, (name: string): void => this.appNameLoadCallback(name));
    }
  }

  private async updateApplicationLabelIdAndName(): Promise<void> {
    let bundleInfo = await commonBundleManager.getBundleInfoByBundleName(this.bundleName);
    this.labelId = bundleInfo?.appInfo?.labelId ?? this.labelId;
    log.showInfo(`updateApplicationLabelId: ${this.labelId}}`);
    this.updateName();
  }

  build() {
    Row() {
      Text(this.appName)
        .draggable(false)
        .id(`${TAG}_ServiceFormName_${this.idIndex}_Text_${this.appName}`)
        .fontSize($r('sys.float.ohos_id_text_size_body3'))
        .minFontScale(sFontScaleUtil.minFontSize)
        .maxFontScale(sFontScaleUtil.maxFontSize)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
        .lineHeight(this.fontScale.serviceFormNameLineHeight)
        .textAlign(TextAlign.Center)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(2)
        .constraintSize({ maxWidth: StyleConstants.PERCENTAGE_80 })
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .margin({ top: 4 })
  }
}