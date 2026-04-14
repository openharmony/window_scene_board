/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { formInfo } from '@kit.FormKit';
import { CheckEmptyUtils, LogDomain, LogHelper, } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG = 'FormComponentConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/*
 * formLayoutSize * displayRate = realLayoutSize
 */
export class FormComponentDisplayStyle {
  public formLayoutSize?: Size;
  public displayRate: number = 1;
}

/**
 * FormComponent config
 */
export class FormComponentConfig {
  private static instance: FormComponentConfig;
  protected standardDimensionSize: Map<number, Size> = new Map();
  public mOuterFormStackExpandScale: number = 1;
  public setOuterFormStackExpandScale(scale: number): void {
    this.mOuterFormStackExpandScale = scale;
  }

  protected constructor() {
    if (DeviceHelper.isPad()) {
      this.standardDimensionSize.set(formInfo.FormDimension.Dimension_1_2, { width: 160, height: 58 });
      this.standardDimensionSize.set(formInfo.FormDimension.Dimension_2_2, { width: 160, height: 160 });
      this.standardDimensionSize.set(formInfo.FormDimension.Dimension_2_4, { width: 360, height: 160 });
      this.standardDimensionSize.set(formInfo.FormDimension.Dimension_4_4, { width: 360, height: 360 });
    } else if (DeviceHelper.isPC()) {
      this.standardDimensionSize.set(formInfo.FormDimension.Dimension_1_2, { width: 180, height: 64 });
      this.standardDimensionSize.set(formInfo.FormDimension.Dimension_2_2, { width: 180, height: 180 });
      this.standardDimensionSize.set(formInfo.FormDimension.Dimension_2_4, { width: 412, height: 180 });
      this.standardDimensionSize.set(formInfo.FormDimension.Dimension_4_4, { width: 412, height: 412 });
      this.standardDimensionSize.set(formInfo.FormDimension.DIMENSION_6_4, { width: 640, height: 412 });
    } else {
      this.standardDimensionSize.set(formInfo.FormDimension.Dimension_1_2, { width: 140, height: 54 });
      this.standardDimensionSize.set(formInfo.FormDimension.Dimension_2_2, { width: 140, height: 140 });
      this.standardDimensionSize.set(formInfo.FormDimension.Dimension_2_4, { width: 300, height: 140 });
      this.standardDimensionSize.set(formInfo.FormDimension.Dimension_4_4, { width: 300, height: 312 });
      this.standardDimensionSize.set(formInfo.FormDimension.DIMENSION_6_4, { width: 484, height: 300 });
    }
  }

  /**
   * Get FormComponent configuration instance.
   *
   * @return {object} FormComponentConfig singleton
   */
  static getInstance(): FormComponentConfig {
    if (FormComponentConfig.instance == null) {
      FormComponentConfig.instance = new FormComponentConfig();
    }
    return FormComponentConfig.instance;
  }

  /**
   * Get form size by dimension.
   *
   * @param cardDimension
   * @return Size | undefined
   */
  public getFormComponentDisplayStyle(cardDimension: number, layoutSize: Size): FormComponentDisplayStyle {
    let style: FormComponentDisplayStyle = new FormComponentDisplayStyle();
    style.formLayoutSize = layoutSize;
    if (CheckEmptyUtils.isEmpty(layoutSize) || layoutSize.width === 0 || layoutSize.height === 0) {
      return style;
    }
    let formLayoutSize: Size | undefined = this.standardDimensionSize.get(cardDimension);
    if (!formLayoutSize) {
      return style;
    }
    let widthRate: number = formLayoutSize.width / layoutSize.width;
    let heightRate: number = formLayoutSize.height / layoutSize.height;
    style.formLayoutSize = { width: formLayoutSize.width, height: formLayoutSize.height };
    if (widthRate > heightRate) {
      style.formLayoutSize.height = layoutSize.height * widthRate;
      style.displayRate = 1 / widthRate;
    } else {
      style.formLayoutSize.width = layoutSize.width * heightRate;
      style.displayRate = 1 / heightRate;
    }
    log.showDebug('getDisplaySize: { %{public}d, %{public}d }, rate: %{public}d',
      style.formLayoutSize.width, style.formLayoutSize.height, style.displayRate);
    return style;
  }
}
