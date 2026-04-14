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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { desktopUtil } from '@ohos/componenthelper';
import {
  CardItemInfo,
  FormCommonUtil,
  StyleConstants,
  GridLayoutUtil,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  FormComponentConfig,
  FormComponentDisplayStyle
} from '@ohos/launchercommon/src/main/ets/form/model/FormComponentConfig';
import { FormItemBuilderInterface, FormItemParam, FormNameParam } from '../common/FormItemBuilderInterface';
import ThisStyleConstants from '../common/constants/FormStyleConstants';
import { FormCenterViewData } from '../viewmodel/FormCenterViewData';
import { FormCenterViewModel } from '../viewmodel/FormCenterViewModel';
import { FormStyleConfig } from '../common/FormStyleConfig';
import { launcherStatusUtil } from '@ohos/windowscene/src/main/ets/TsIndex';

const TAG = 'DesktopForm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export default class DesktopForm implements FormItemBuilderInterface {
  private isFormCenter: boolean = false;
  private formRate: number = 1;

  constructor(isFormCenter?: boolean, formRate?: number) {
    this.isFormCenter = isFormCenter ?? false;
    if (this.isFormCenter) {
      this.formRate = formRate ?? this.formRate;
    }
  }

  public getFormDisplaySize(cardDimension: number): Size {
    let formSize: Size = { width: 0, height: 0 };
    if (this.isFormCenter) {
      let formConfig: FormStyleConfig = FormStyleConfig.getInstance();
      formSize.height = Number(formConfig.mFormHeight.get(String(cardDimension))) * this.formRate;
      formSize.width = Number(formConfig.mFormWidth.get(String(cardDimension))) * this.formRate;
    } else {
      let formModel: FormCenterViewModel = FormCenterViewModel.getInstance();
      formSize.height = formModel.getFormDisplaySize(cardDimension, false);
      formSize.width = formModel.getFormDisplaySize(cardDimension, true);
    }
    return formSize;
  }

  public getScale(cardDimension: number): number {
    return FormCenterViewData.getInstance().getFormDimensionScale(cardDimension);
  }

  public applyFormParentAttribute(size: SizeOptions, radius: number):
    AttributeModifier<StackAttribute> {
    return new FormScaleAttribute(size, radius);
  }

  public applyFormCenterAttribute(): AttributeModifier<ColumnAttribute> {
    return new FormCenterAttribute();
  }

  public applyFormManagerAttribute<T extends CommonMethod<T>>(backgroundColor: ResourceColor, showShadow: boolean,
    size: SizeOptions, radius: number, transparentShadow?: boolean): AttributeModifier<T> {
    return new FormManagerAttribute(backgroundColor, showShadow, size, radius, transparentShadow);
  }

  public buildView(): WrappedBuilder<FormItemParam[]> {
    return wrapBuilder(buildFormItem);
  }

  public buildFormNameView(): WrappedBuilder<FormNameParam[]> {
    return wrapBuilder(formNameView);
  }
}

class FormScaleAttribute implements AttributeModifier<StackAttribute> {
  private size: SizeOptions = {};
  private radius: number = 0;

  constructor(size: SizeOptions, radius: number) {
    this.size = size;
    this.radius = radius;
  }

  applyNormalAttribute(instance: StackAttribute): void {
    instance
      .size(this.size)
      .borderRadius(this.radius)
  }
}

class FormCenterAttribute implements AttributeModifier<ColumnAttribute> {
  applyNormalAttribute(instance: ColumnAttribute): void {
    instance.shadow({
      radius: $r('app.float.normal_form_center_radius'),
      color: $r('app.color.normal_form_center_shadow_color'),
      offsetY: $r('app.float.normal_form_center_offset')
    })
  }
}

class FormManagerAttribute<T extends CommonMethod<T>> implements AttributeModifier<T> {
  private backgroundColor: ResourceColor;
  private showShadow: boolean;
  private size: SizeOptions;
  private radius: number;
  private transparentShadow: boolean | undefined;

  constructor(backgroundColor: ResourceColor, showShadow: boolean,
    size: SizeOptions, radius: number, transparentShadow?: boolean) {
    this.backgroundColor = backgroundColor;
    this.showShadow = showShadow;
    this.size = size;
    this.radius = radius;
    this.transparentShadow = transparentShadow;
  }

  applyNormalAttribute(instance: T): void {
    instance.backgroundColor(this.backgroundColor)
      .size(this.size)
      .borderRadius(this.radius)
      .shadow(this.showShadow ?
        {
          radius: $r('app.float.normal_form_manager_radius'),
          color: this.transparentShadow ? $r('app.color.gradient_form_manager_shadow_color') : $r('app.color.normal_form_manager_shadow_color'),
          offsetY: $r('app.float.normal_form_manager_offset')
        } : null)
  }
}

@Builder
function formNameView(param: FormNameParam) {
  Text(param.formDescription)
    .draggable(false)
    .fontSize($r('sys.float.ohos_id_text_size_body3'))
    .fontColor($r('sys.color.ohos_id_color_text_secondary'))
    .fontWeight(FontWeight.Regular)
    .height(ThisStyleConstants.FORM_SERVICE_FORM_NAME_NUM_LINE_HEIGHT)
    .maxLines(1)
    .textAlign(TextAlign.Center)
    .textOverflow({ overflow: TextOverflow.Ellipsis })
    .id(`${TAG}_${param.index}_Text_${param.formDescription}`)
    .maxFontScale(StyleConstants.FONT_MAX_SCALE_FORM_TEXT)
}

@Builder
function buildFormItem(config: FormItemParam) {
  DesktopFormItem({
    formItem: config.formUIConfig.formItem,
    formRate: config.formUIConfig.formScale,
    cardId: config.formUIConfig.cardId,
    idIndex: config.formUIConfig.index,
    want: config.formUIConfig.want,
    formWidth: config.formUIConfig.formWidth ?? 0,
    formHeight: config.formUIConfig.formHeight ?? 0,
    formRadius: config.formUIConfig.formRadius ?? 0,
    formOpacity: config.formUIConfig.formOpacity ?? 1,
    onAcquired: config.event.onAcquired,
    onLoad: config.event.onLoad,
    onDisappear: config.event.onDisappear
  })
}

@Component
struct DesktopFormItem {
  private formItem: CardItemInfo = new CardItemInfo();
  private want: Want = {};
  private idIndex: number = 0;
  private formRate: number = 1;
  private cardId: string = '';
  private formWidth: number = 0;
  private formHeight: number = 0;
  private formRadius: number = 0;
  private formOpacity: number = 1;
  private formComponentStyle: FormComponentDisplayStyle = new FormComponentDisplayStyle();
  private formComponentConfig: FormComponentConfig = FormComponentConfig.getInstance();
  private onAcquired: Callback<string> = (cardId: string) => {
  };
  private onLoad: Callback<void> = () => {
  };
  private onDisappear: Callback<void> = () => {
  };
  @StorageLink('isPortrait') isPortrait: boolean = false;

  aboutToAppear(): void {
    let formConfig: FormStyleConfig = FormStyleConfig.getInstance();
    this.formHeight = this.formHeight ? this.formHeight :
      Number(formConfig.mFormHeight.get(String(this.formItem.cardDimension)));
    this.formWidth = this.formWidth ? this.formWidth :
      Number(formConfig.mFormWidth.get(String(this.formItem.cardDimension)));
    this.updateFormDisplay();
    log.showWarn(`formItem width: ${this.formWidth}, height: ${this.formHeight}`);
  }

  private updateFormDisplay(): void {
    log.showWarn('updateFormDisplay formSizeChange');
    this.formComponentStyle = this.formComponentConfig.getFormComponentDisplayStyle(this.formItem.cardDimension,
      { width: this.formWidth * this.formRate, height: this.formHeight * this.formRate });
  }

  private updateFormSize(change: boolean): Size | undefined {
    log.showInfo('change only form update');
    return this.formComponentStyle.formLayoutSize;
  }

  private updateFormScale(change: boolean): ScaleOptions {
    log.showInfo('change only form update');
    return { x: this.formComponentStyle.displayRate, y: this.formComponentStyle.displayRate };
  }

  @Builder
  OuterFormComponent() {
    Stack() {
      FormComponent({
        id: FormCommonUtil.transformCardId(this.formItem.cardId),
        name: this.formItem.cardName,
        bundle: this.formItem.bundleName,
        ability: this.formItem.abilityName,
        module: this.formItem.moduleName,
        dimension: this.formItem.cardDimension,
        want: this.want
      })
        .id(`${TAG}_Outer_FormComponent_${this.idIndex}`)
        .size(this.updateFormSize(this.isPortrait))
        .scale(this.updateFormScale(this.isPortrait))
        .borderRadius(this.formRadius)
        .allowUpdate(true)
        .onAcquired((form: FormCallbackInfo) => {
          log.showWarn(`FormComponent onAcquired formId=${form?.idString}`);
          this.cardId = String(form?.idString);
          this.onAcquired(this.cardId);
        })
        .onLoad(() => {
          this.onLoad();
        })
        .onError((error) => {
          log.showError(`FormComponent error msg: ${error?.msg}, cardId: ${this.formItem.cardId}`);
        })
        .onDisAppear(() => {
          this.onDisappear();
        })
    }
    .id(`${TAG}_FormComponent_${this.idIndex}`)
    .enabled(false)
    .hitTestBehavior(HitTestMode.None)
    .hoverEffect(HoverEffect.None)
    .size({ width: GridLayoutUtil.getFloorVp(this.formWidth * this.formRate),
      height: GridLayoutUtil.getFloorVp(this.formHeight * this.formRate) })
    .clip(true)
  }

  build() {
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      this.OuterFormComponent()
    } else {
      FormComponent({
        id: FormCommonUtil.transformCardId(this.formItem.cardId),
        name: this.formItem.cardName,
        bundle: this.formItem.bundleName,
        ability: this.formItem.abilityName,
        module: this.formItem.moduleName,
        dimension: this.formItem.cardDimension,
        want: this.want
      })
        .id(`${TAG}_FormComponent_${this.idIndex}`)
        .enabled(false)
        .hitTestBehavior(HitTestMode.None)
        .hoverEffect(HoverEffect.None)
        .size({ width: this.formWidth, height: this.formHeight })
        .scale({ x: this.formRate, y: this.formRate })
        .opacity(this.formOpacity)
        .borderRadius(this.formRadius)
        .allowUpdate(true)
        .onAcquired((form: FormCallbackInfo) => {
          log.showWarn(`FormComponent onAcquired formId=${form?.idString}`);
          this.cardId = String(form?.idString);
          this.onAcquired(this.cardId);
        })
        .onLoad(() => {
          this.onLoad();
        })
        .onError((error) => {
          log.showError(`FormComponent error msg: ${error?.msg}, cardId: ${this.formItem.cardId}`);
        })
        .onDisAppear(() => {
          this.onDisappear();
        })
    }
  }
}