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

import { CardItemInfo, CommonConstants, FormCommonUtil } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { baseStateMgr, DarkModeState, StateType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { FormItemBuilderInterface, FormItemParam } from '../../../interfaces/FormItemBuilderInterface';
import ScreenLockFormModel from '../../../../default/viewmodel/ScreenLockFormModel';
import {
  clockLayoutHelper
} from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutHelper';
import { FormUtil } from '../../../../default/util/FormUtil';

const TAG = 'ScreenLockForm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
const FORM_BACKGROUND_LIGHT: ESObject = {
  rate: 1,
  lightUpDegree: -55 / 255,
  cubicCoeff: 0,
  quadCoeff: 0,
  fraction: 0,
  saturation: 2,
  negRGB: [2.3, 4.5, 2],
  posRGB: [0.5, 2, 0.5],
};
const FORM_BACKGROUND_DARK: ESObject = {
  rate: 1,
  lightUpDegree: -15 / 255,
  cubicCoeff: 0,
  quadCoeff: 0,
  fraction: 0,
  saturation: 2,
  negRGB: [2.3, 4.5, 2],
  posRGB: [0.5, 2, 0.5],
};

const FORM_FOLD_GRIDWIDTH: number = 90;
const DEFAULT_FIX_VALUE: number = 24;
const SIG_DIS_FIX_VALUE: number = 32;

export default class ScreenLockForm implements FormItemBuilderInterface {
  public buildView(): WrappedBuilder<FormItemParam[]> {
    return wrapBuilder(buildFormItem)
  }
}

@Builder
function buildFormItem(config: FormItemParam) {
  ScreenLockFormItem({
    formItem: config.formUIConfig.formItem,
    formRate: config.formUIConfig.formScale,
    cardId: config.formUIConfig.cardId,
    idIndex: config.formUIConfig.index,
    formDisplayHeight: config.formUIConfig.formDisplayHeight,
    formDisplayWidth: config.formUIConfig.formDisplayWidth,
    onAcquired: config.event.onAcquired,
    onLoad: config.event.onLoad,
    isSupportBrightness: Boolean(config.formUIConfig.isSupportBrightness),
    formOpacity: config.formUIConfig.formOpacity ?? 1,
    hasFadeInAnimation: !!config.formUIConfig.hasFadeInAnimation,
  })
}

@Component
struct ScreenLockFormItem {
  private formModel: ScreenLockFormModel = new ScreenLockFormModel();
  public formItem: CardItemInfo = new CardItemInfo();
  public idIndex: number = 0;
  public formRate: number = 1;
  public gridWidth: number = 0;
  public cardId: string = '';
  public onAcquired: Callback<string> = (cardId: string) => {};
  public onLoad: Callback<void> = () => {};
  public formDisplayHeight: number = 0;
  public formDisplayWidth: number = 0;
  public hasFadeInAnimation?: boolean;
  public isSupportBrightness: boolean = false;
  public colBackgroundColor: ResourceColor = $r('app.color.transparent_form_background_color');

  @State darkModeState: DarkModeState = baseStateMgr.getBaseState(StateType.TYPE_DARK_MODE) as DarkModeState;
  @State formOpacity: number = 1;

  aboutToAppear(): void {
    this.gridWidth = FormUtil.getGridWidth();
    if (this.hasFadeInAnimation) {
      this.formOpacity = 0;
      animateTo({
        delay: 250,
        duration: 250,
        curve: Curve.Sharp,
      }, () => {
        this.formOpacity = 1;
      })
    }
  }

  build() {
    Stack() {
      Column()
        .backgroundColor(this.isSupportBrightness ? Color.Red : this.colBackgroundColor)
        /*.backgroundBrightnessInternal(this.isSupportBrightness ?
          (this.darkModeState?.isDarkMode ? FORM_BACKGROUND_DARK : FORM_BACKGROUND_LIGHT) :
          undefined)*/
        .borderRadius(this.formDisplayHeight / 2)
        .size({ width: this.formDisplayWidth, height: this.formDisplayHeight })

      FormComponent({
        id: FormCommonUtil.transformCardId(this.formItem.cardId),
        name: this.formItem.cardName,
        bundle: this.formItem.bundleName,
        ability: this.formItem.abilityName,
        module: this.formItem.moduleName,
        dimension: this.formItem.cardDimension,
        renderingMode: 1,
        want: this.formModel.getScreenLockWant()
      })
        .id(`${TAG}_FormComponent_${this.idIndex}`)
        .enabled(false)
        .hitTestBehavior(HitTestMode.None)
        .hoverEffect(HoverEffect.None)
        .size({
          width: (this.formItem.cardDimension === CommonConstants.CARD_DIMENSION_1x2 ? 2 : 1) *
          this.gridWidth - (DEFAULT_FIX_VALUE),
          height: this.gridWidth - (DEFAULT_FIX_VALUE)
        })
        .borderRadius(this.formDisplayHeight / 2)
        .opacity(this.formOpacity)
        .allowUpdate(true)
        .onAcquired((form: FormCallbackInfo) => {
          log.showWarn(`FormComponent onAcquired formId=${form?.idString}`);
          this.cardId = String(form?.idString);
          this.onAcquired(this.cardId);
        })
        .onError((error) => {
          log.showError(`FormComponent error msg: ${error.msg}, cardId: ${this.formItem.cardId}`);
        })
    }
    .size({
      width: this.formDisplayWidth,
      height: this.formDisplayHeight,
    })
  }
}