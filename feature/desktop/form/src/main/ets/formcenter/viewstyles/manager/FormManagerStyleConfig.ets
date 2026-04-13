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

import FormStyleConstants from '../../../default/common/constants/FormStyleConstants';
import { FormCenterViewModel } from '../../viewmodel/FormCenterViewModel';
import { FormManagerStyle } from '../FormManagerStyle';
import { BaseStyleConfig } from './BaseStyleConfig';
import { FormCenterLocation } from './FormCenterEnum';
import { FormUtil } from '../../../default/util/FormUtil';

export class FormManagerStyleConfig extends BaseStyleConfig<FormManagerStyle> {
  private static instance?: FormManagerStyleConfig;
  private constructor() {
    super();
    this.initStyle();
  }

  public static getInstance(): FormManagerStyleConfig {
    if (!FormManagerStyleConfig.instance) {
      FormManagerStyleConfig.instance = new FormManagerStyleConfig();
    }
    return FormManagerStyleConfig.instance;
  }

  // 默认使用init方法进行初始化，如需本地定制，可以使用基类函数的setStyle方法
  public initStyle(): void {
    let style: FormManagerStyle = new FormManagerStyle();
    this.setStyle(FormCenterLocation.DESKTOP, style);

    let landscapeStyle: FormManagerStyle = new FormManagerStyle();
    this.adaptLandscape(landscapeStyle);
    this.setStyle(FormCenterLocation.LANDSCAPE, landscapeStyle);

    let outerStyle: FormManagerStyle = new FormManagerStyle();
    this.adaptOuterLauncher(outerStyle);
    this.setStyle(FormCenterLocation.OUTER, outerStyle);

    let screenLockStyle: FormManagerStyle = new FormManagerStyle();
    this.adaptScreenLock(screenLockStyle);
    this.setStyle(FormCenterLocation.SCREEN_LOCK, screenLockStyle);

    let innerStyle: FormManagerStyle = new FormManagerStyle();
    this.setStyle(FormCenterLocation.INSIDE_APP, innerStyle);

    let asdeStyle: FormManagerStyle = new FormManagerStyle();
    this.adaptAsde(asdeStyle);
    this.setStyle(FormCenterLocation.ASDE, innerStyle);
  }

  public getStyle(): FormManagerStyle {
    let location: FormCenterLocation = FormCenterViewModel.getInstance().getFormCenterLocation();
    const isLandscape: boolean = FormUtil.isPlateLandscape();
    if (isLandscape) {
      return super.getStyle(FormCenterLocation.LANDSCAPE) ?? new FormManagerStyle();
    }
    if (FormCenterViewModel.getInstance().isShowButtonByAsdeForNegativeScreen()) {
      return super.getStyle(FormCenterLocation.ASDE) ?? new FormManagerStyle();
    }
    return super.getStyle(location) ?? new FormManagerStyle();
  }

  private adaptOuterLauncher(style: FormManagerStyle): void {
    style.swiperLayoutStyle.swiperItemHeight = 20;
    style.swiperLayoutStyle.isShowThemeCard = false;
    style.swiperLayoutStyle.isShowDescription = false;
    style.swiperLayoutStyle.buttonTextSize = $r('sys.float.ohos_id_text_size_body2');
    style.swiperLayoutStyle.buttonWidth = 'auto';
    style.swiperLayoutStyle.buttonHeight = 32;
    style.swiperLayoutStyle.addToDeskTopMaxLines = 1;
    style.swiperLayoutStyle.addToDeskTopTextOverflow = { overflow: TextOverflow.Ellipsis };
    style.swiperLayoutStyle.buttonPadding = {
      top: 0,
      bottom: 0,
      left: 16,
      right: 16,
    };
    style.swiperLayoutStyle.buttonColumnMargin = {
      left: 16,
      right: 16,
      top: 0,
      bottom: 28
    };
  }

  private adaptScreenLock(style: FormManagerStyle): void {
    style.swiperLayoutStyle.buttonText = $r('app.string.add_to_screen_lock');
  }

  private adaptLandscape(style: FormManagerStyle): void {
    style.swiperLayoutStyle.isShowDescription = false;
    style.swiperLayoutStyle.swiperItemHeight = 0;
    style.swiperLayoutStyle.isLandSpace = true;
    style.swiperLayoutStyle.buttonWidth = 218;
  }

  private adaptAsde(style: FormManagerStyle): void {
    style.swiperLayoutStyle.descriptionStyle.appNameMargin = {
      top: FormStyleConstants.FORM_NAME_TOP_BOTTOM_MARGIN_BY_ASDE,
      left: style.swiperLayoutStyle.descriptionMargin,
      right: style.swiperLayoutStyle.descriptionMargin
    }
    style.swiperLayoutStyle.descriptionStyle.descriptionMargin = {
      top: 2,
      bottom: FormStyleConstants.FORM_NAME_TOP_BOTTOM_MARGIN_BY_ASDE,
      left: style.swiperLayoutStyle.descriptionMargin,
      right: style.swiperLayoutStyle.descriptionMargin
    }
    style.swiperLayoutStyle.descriptionStyle.columnHeight = 102 - 24;
    style.swiperLayoutStyle.buttonColumnHeight = FormStyleConstants.FORM_SWIPER_TWO_BOTTOM_HEIGHT;
    style.swiperLayoutStyle.buttonColumnMargin = {
      left: 16,
      right: 16,
      top: FormStyleConstants.FORM_ADD_BUTTON_TOP_BY_ASDE,
      bottom: 28
    };
  }
}