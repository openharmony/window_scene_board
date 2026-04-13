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

import { Want } from '@kit.AbilityKit';
import { launcherStatusUtil } from '@ohos/windowscene';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  CardItemInfo,
  FormCommonUtil,
  GridLayoutUtil,
  OverflowFormInfoUtil } from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  FormComponentConfig,
  FormComponentDisplayStyle,
} from '@ohos/launchercommon/src/main/ets/form/model/FormComponentConfig';
import {
  FormBasicParams,
  FormComponentBasicData,
  FormComponentBasicEvent
} from '@ohos/launchercommon/src/main/ets/manager/CardNodeControllerManager';
import {
  CardNodeController
} from '@ohos/launchercommon/src/main/ets/buildernode/CardNodeController';
import {
  FormItemBuilderInterface,
  FormInLineBorderParam,
  FormItemParam,
} from '../../../interfaces/FormItemBuilderInterface';
import { FormStyleConfig } from '../../../../default/common/FormStyleConfig';
import FormConstants from '../../../../default/common/constants/FormConstants';

const TAG = 'CommonForm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export default class CommonForm implements FormItemBuilderInterface {
  public buildView(): WrappedBuilder<FormItemParam[]> {
    return wrapBuilder(buildFormItem);
  }
}

@Builder
function buildFormItem(config: FormItemParam) {
  CommonFormItem({
    formItem: config.formUIConfig.formItem,
    formRate: config.formUIConfig.formScale,
    cardId: config.formUIConfig.cardId,
    idIndex: config.formUIConfig.index,
    want: config.formUIConfig.want,
    formWidth: config.formUIConfig.formWidth ?? 0,
    formHeight: config.formUIConfig.formHeight ?? 0,
    formRadius: config.formUIConfig.formRadius ?? 0,
    onAcquired: config.event.onAcquired,
    onLoad: config.event.onLoad,
    onError: config.event.onError,
    formOpacity: config.formUIConfig.formOpacity ?? 1,
    hasFadeInAnimation: !!config.formUIConfig.hasFadeInAnimation,
  })
}

@Component
struct CommonFormItem {
  public formItem: CardItemInfo = new CardItemInfo();
  public want: Want = {};
  public idIndex: number = 0;
  public formRate: number = 1;
  public cardId: string = '';
  public formWidth: number = 0;
  public formHeight: number = 0;
  public formRadius: number = 0;
  public hasFadeInAnimation?: boolean;
  public onAcquired: Callback<string> = (cardId: string) => {};
  public onError: Callback<string> = (errorMsg: string) => {};
  public onLoad: Callback<void> = () => {};
  private formComponentStyle: FormComponentDisplayStyle = new FormComponentDisplayStyle();
  private formComponentConfig: FormComponentConfig = FormComponentConfig.getInstance();
  private cardController: CardNodeController | null = null;
  @State formOpacity: number = 1;
  // 仅为触发更新卡片尺寸
  @StorageLink('isPortrait') isPortrait: boolean = false;

  private updateFormDisplay(): void {
    log.showWarn('updateFormDisplay formSizeChange');
    this.formComponentStyle = this.formComponentConfig.getFormComponentDisplayStyle(this.formItem.cardDimension,
      { width: this.formWidth * this.formRate, height: this.formHeight * this.formRate });
  }

  private updateFormSize(change: boolean): Size | undefined {
    log.showInfo(`updateFormSize width: ${this.formComponentStyle.formLayoutSize?.width},` +
      `height: ${this.formComponentStyle.formLayoutSize?.height}`);
    return this.formComponentStyle.formLayoutSize;
  }

  private updateFormScale(change: boolean): ScaleOptions {
    log.showInfo(`updateFormScale displayRate: ${this.formComponentStyle.displayRate}`);
    return { x: this.formComponentStyle.displayRate, y: this.formComponentStyle.displayRate };
  }

  private getFormComponentBasicData(): FormComponentBasicData {
    return new FormComponentBasicData(
      this.formItem.cardId,
      this.formItem.cardName,
      this.formItem.bundleName,
      this.formItem.abilityName,
      this.formItem.moduleName,
      this.formItem.cardDimension,
      this.want,
      this.formRadius,
      launcherStatusUtil.getShowOutLauncherStatus() ?
        this.formComponentStyle.formLayoutSize?.width as number : GridLayoutUtil.getFloorVp(this.formWidth),
      launcherStatusUtil.getShowOutLauncherStatus() ?
        this.formComponentStyle.formLayoutSize?.height as number : GridLayoutUtil.getFloorVp(this.formHeight),
      launcherStatusUtil.getShowOutLauncherStatus() ?
        `${TAG}_Outer_FormComponent_${this.idIndex}` : `${TAG}_FormComponent_${this.idIndex}`,
      HoverEffect.None,
      OverflowFormInfoUtil.isGameCard(this.formItem)
    );
  }

  private getFormComponentBasicEvent(): FormComponentBasicEvent {
    // 基本事件
    return {
      // 组件内部异常回调
      onError: (error) => {
        let errorMsg: string = `errorcode: ${error?.errcode}, errorMsg: ${error?.msg}`;
        log.showError(`FormComponent error, ${errorMsg}, cardId: ${this.formItem.cardId}`);
        this.onError(errorMsg);
      },
      // 唯一性标识更新，会触发UI组件上下树
      onAcquired: (form: FormCallbackInfo) => {
        log.showWarn(`FormComponent onAcquired formId=${form.idString}`);
        this.cardId = form.idString;
        this.onAcquired(this.cardId);
      },
      // 卡片点击启动， 记录打点信息
      onRouter: () => {
      },
      // 卡片uninstall回调
      onUninstall: (form: FormCallbackInfo) => {
      },
      onLoad: () => {
        this.onLoad();
      },
      onTouch: () => {}
    }
  }

  @Builder
  OuterFormComponent() {
    Stack() {
      NodeContainer(this.cardController)
        .size(this.updateFormSize(this.isPortrait))
        .scale(this.updateFormScale(this.isPortrait))
        .opacity(this.formOpacity)
        .borderRadius(this.formRadius)
    }
    .enabled(false)
    .hitTestBehavior(HitTestMode.None)
    .size({ width: GridLayoutUtil.getFloorVp(this.formWidth * this.formRate),
      height: GridLayoutUtil.getFloorVp(this.formHeight * this.formRate) })
    .clip(true)
  }

  aboutToAppear(): void {
    let formConfig: FormStyleConfig = FormStyleConfig.getInstance();
    this.formHeight = this.formHeight ? this.formHeight :
      Number(formConfig.mFormHeight.get(String(this.formItem.cardDimension)));
    this.formWidth = this.formWidth ? this.formWidth :
      Number(formConfig.mFormWidth.get(String(this.formItem.cardDimension)));
    this.updateFormDisplay();
    this.cardController = new CardNodeController(new FormBasicParams(
      this.getFormComponentBasicData(), this.getFormComponentBasicEvent()), TAG);
    log.showWarn(`formItem width: ${this.formWidth}, height: ${this.formHeight}`);
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

  aboutToDisappear(): void {
    this.cardController = null;
  }

  @Builder
  DefaultFormComponent() {
    NodeContainer(this.cardController)
      .enabled(false)
      .hitTestBehavior(HitTestMode.None)
      .size({ width: GridLayoutUtil.getFloorVp(this.formWidth), height: GridLayoutUtil.getFloorVp(this.formHeight)})
      .scale({ x: this.formRate, y: this.formRate })
      .opacity(this.formOpacity)
  }

  build() {
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      this.OuterFormComponent()
    } else {
      this.DefaultFormComponent()
    }
  }
}

export class FormInLineBorder {
  public static buildView(): WrappedBuilder<FormInLineBorderParam[]> {
    return wrapBuilder(buildFormInLineBorder);
  }
}

@Builder
function buildFormInLineBorder(config: FormInLineBorderParam) {
  Stack() {
  }
  .width('100%')
  .height('100%')
  .hitTestBehavior(HitTestMode.None)
  .borderRadius(config.borderRadius)
  .border({
    width: 1,
    radius: config.borderRadius,
    color: $r('app.color.form_center_form_inline_color'),
  })
}