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

import curves from '@ohos.curves';
import Want from '@ohos.app.ability.Want';
import { CommonConstants, FormCommonUtil, GridLayoutUtil } from '@ohos/launchercommon';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBScenePanelManager, SCBScreenSessionManager, launcherStatusUtil } from '@ohos/windowscene';
import { clockLayoutHelper } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutHelper';
import FormStyleConstants from '../common/constants/FormStyleConstants';
import { FormViewModel } from '../viewmodel/FormViewModel';
import { FormStyleConfig } from '../common/FormStyleConfig';
import { FormCenterViewModel } from '../../formcenter/viewmodel/FormCenterViewModel';

const TAG = 'FormUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

const FORM_ZOOM_SIZE_1X2 = 1.2;
const FORM_ZOOM_SIZE_2X4 = 0.8;
const FORM_ZOOM_SIZE_4X4 = 0.75;
const FORM_ZOOM_SIZE_6X4 = 0.55;
const FORM_ZOOM_SIZE_NORMAL = 1;
const DESKTOP_FORM_RADIUS = 16;
const FORM_TRANSPARENCY_COLOR = '#00000000';
const ROTATION_0 = 0;
const ROTATION_180 = 180;
const ROTATION_360 = 360;

export class FormUtil {
  public static serviceFormScale: number = 1;
  private static formScaleMap: Map<number, number> = new Map<number, number>([
    [CommonConstants.CARD_DIMENSION_1x1, 1.2],
    [CommonConstants.CARD_DIMENSION_1x2, 1.2],
    [CommonConstants.CARD_DIMENSION_2x4, 0.8],
    [CommonConstants.CARD_DIMENSION_4x4, 0.75],
    [CommonConstants.CARD_DIMENSION_6x4, 0.55]
  ]);

  /**
   * Get FormComponent want parameters.
   *
   * @param isTransparent is form transparent
   * @param formLocation form location
   * @returns want
   */
  public static getWant(isTransparent: boolean, formLocation?: Number): Want {
    let want: Want = FormCommonUtil.getCommonWant({ isTransparent: isTransparent, formLocation: formLocation });

    if (!want.parameters) {
      want.parameters = {};
    }

    if (isTransparent) {
      want.parameters[CommonConstants.FORM_BACKGROUND_TRANSPARENCY] =
        DeviceHelper.isPhone() ? FORM_TRANSPARENCY_COLOR : CommonConstants.TRANSPARENT_FORM_BG_PANEL_COLOR;
    }

    return want;
  }

  /**
   * Get form display size.
   *
   * @param dimension form dimension
   * @param isWidth is width or height
   * @returns display size
   */
  public static getFormDisplaySize(dimension: number, isWidth: boolean): number {
    let formSize = 0;
    if (dimension === undefined || dimension === null) {
      return formSize;
    }

    if (isWidth) {
      formSize = FormViewModel.getInstance().getFormStyleConfig().mFormWidth.get(dimension.toString()) as number;
    } else {
      formSize = FormViewModel.getInstance().getFormStyleConfig().mFormHeight.get(dimension.toString()) as number;
    }

    if (dimension === CommonConstants.CARD_DIMENSION_1x2) {
      return formSize * FORM_ZOOM_SIZE_1X2;
    } else if (dimension === CommonConstants.CARD_DIMENSION_2x4) {
      return formSize * FORM_ZOOM_SIZE_2X4;
    } else if (dimension === CommonConstants.CARD_DIMENSION_4x4) {
      return formSize * FORM_ZOOM_SIZE_4X4;
    } else if (dimension === CommonConstants.CARD_DIMENSION_6x4) {
      return formSize * FORM_ZOOM_SIZE_6X4;
    } else {
      return formSize;
    }
  }

  /**
   * Get form display size in px.
   *
   * @param dimension form dimension
   * @param isWidth is width or height
   * @returns display size
   */
  public static getFormDisplayPXSize(dimension: number, isWidth: boolean): string {
    let size = FormUtil.getFormDisplaySize(dimension, isWidth);
    return `${Math.floor(vp2px(size))}px`;
  }

  /**
   * Get form scale options.
   *
   * @param dimension card dimension
   * @returns scaleOptions
   */
  public static getFormScaleOptions(dimension: number): ScaleOptions {
    let scaleOption: ScaleOptions = { x: 1, y: 1 };
    if (!DeviceHelper.isPhone()) {
      return scaleOption;
    }

    if (dimension === CommonConstants.CARD_DIMENSION_1x2) {
      scaleOption.x = FORM_ZOOM_SIZE_1X2;
      scaleOption.y = FORM_ZOOM_SIZE_1X2;
      return scaleOption;
    } else if (dimension === CommonConstants.CARD_DIMENSION_2x4) {
      scaleOption.x = FORM_ZOOM_SIZE_2X4;
      scaleOption.y = FORM_ZOOM_SIZE_2X4;
      return scaleOption;
    } else if (dimension === CommonConstants.CARD_DIMENSION_4x4) {
      scaleOption.x = FORM_ZOOM_SIZE_4X4;
      scaleOption.y = FORM_ZOOM_SIZE_4X4;
      return scaleOption;
    } else if (dimension === CommonConstants.CARD_DIMENSION_6x4) {
      scaleOption.x = FORM_ZOOM_SIZE_6X4;
      scaleOption.y = FORM_ZOOM_SIZE_6X4;
      return scaleOption;
    } else {
      return scaleOption;
    }
  }

  /**
   * Get form manager scale.
   *
   * @param dimension card dimension
   * @returns scaleOptions
   */
  public static getFormManagerScale(dimension: number): number {
    let formDimension: number = FORM_ZOOM_SIZE_NORMAL;
    if (!DeviceHelper.isPhone()) {
      return formDimension;
    }

    if (dimension === CommonConstants.CARD_DIMENSION_1x2) {
      formDimension = FORM_ZOOM_SIZE_1X2;
    } else if (dimension === CommonConstants.CARD_DIMENSION_2x4) {
      formDimension = FORM_ZOOM_SIZE_2X4;
    } else if (dimension === CommonConstants.CARD_DIMENSION_4x4) {
      formDimension = FORM_ZOOM_SIZE_4X4;
    } else if (dimension === CommonConstants.CARD_DIMENSION_6x4) {
      formDimension = FORM_ZOOM_SIZE_6X4;
    }
    return formDimension;
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
        scale = FormStyleConstants.FORM_MANAGER_PANEL_SCALE_90;
        break;
      case FormDimension.Dimension_2_2:
      case FormDimension.Dimension_2_4:
      case FormDimension.Dimension_4_4:
      default:
        scale = FormStyleConstants.FORM_MANAGER_PANEL_SCALE_95;
        break;
    }
    return scale;
  }

  /**
   * Get form Curve options.
   *
   * @param dimension card dimension
   * @returns Curve
   */
  public static getPressAnimateCurve(dimension: number): curves.ICurve {
    let curve: curves.ICurve;
    switch (dimension) {
      case FormDimension.Dimension_1_2:
      case FormDimension.Dimension_2_1:
        curve = curves.interpolatingSpring(1, 1, 410, 38);
        break;
      case FormDimension.Dimension_2_2:
      case FormDimension.Dimension_2_4:
        curve = curves.interpolatingSpring(0.5, 1, 350, 35);
        break;
      case FormDimension.Dimension_4_4:
      default:
        curve = curves.interpolatingSpring(0, 1, 240, 28);
        break;
    }
    return curve;
  }

  /**
   * Get form rect radius options.
   *
   * @param dimension card dimension
   * @returns radius ratio
   */
  public static getManagerFormRadius(dimension: number): number {
    let radius: number = FormViewModel.getInstance().getFormStyleConfig().getFormBorderRadius(dimension);
    if (radius === CommonConstants.INVALID_VALUE) {
      radius = DESKTOP_FORM_RADIUS;
    }
    log.showDebug(`getManagerFormRadius: ${radius}`);
    return radius;
  }

  public static getAnimateScale(dimension: number): number {
    const dragItemType: number = AppStorage.get<number>('dragItemType') as number;
    if (dragItemType === CommonConstants.DRAG_FROM_FORM_INTELLIGENT) {
      // 负一屏卡片在桌面新建page落位时不缩小
      return FORM_ZOOM_SIZE_NORMAL;
    }
    return FormUtil.formScaleMap.get(dimension) ?? FORM_ZOOM_SIZE_NORMAL;
  }

  /**
   * set form service form scale options.
   *
   * @param scale
   * @returns radius ratio
   */
  public static setFormServiceScale(scale: number): void {
    log.showInfo(`setFormServiceScale: ${scale}`);
    FormUtil.serviceFormScale = scale;
  }

  /**
   * get form service form scale options.
   *
   * @param nothing
   * @returns radius ratio
   */
  public static getFormServiceScale(): number {
    return FormUtil.serviceFormScale;
  }

  public static isPlateLandscape(): boolean {
    if (DeviceHelper.isPad() || DeviceHelper.isPC() ||
      (DeviceHelper.isFold()  &&
      SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()) ||
      launcherStatusUtil.getShowOutLauncherStatus()) {
      log.showInfo('not a bar machine');
      return false;
    }
    let rotation: number = SCBScenePanelManager.getInstance().getScreenProperty().rotation;
    if (rotation === ROTATION_0 || rotation === ROTATION_180 || rotation === ROTATION_360) {
      log.showInfo('not landscape application');
      return false;
    }
    return true;
  }

  /**
   * 内屏4*4推荐卡片高度，4*4卡片高度根据2*2卡片标准高度*2 + 固定间距（字体缩放时也固定不变） 计算获得
   */
  public static get4x4CardHeight(scale?: number | undefined): number {
    let formConfig: FormStyleConfig = FormStyleConfig.getInstance();
    let formRate: number = scale ? scale : 1;
    let card4x4HeightInner: number = 0;
    let card4x4Height: number | undefined = formConfig.mFormHeight.get(String(CommonConstants.CARD_DIMENSION_4x4));
    let card2x2Height: number | undefined = formConfig.mFormHeight.get(String(CommonConstants.CARD_DIMENSION_2x2));
    if (launcherStatusUtil.getShowOutLauncherStatus() && card4x4Height !== undefined) {
      card4x4HeightInner = Number(card4x4Height) * formRate;
    } else if (card2x2Height !== undefined) {
      card4x4HeightInner = GridLayoutUtil.getFloorVp(Number(card2x2Height)) * 2 * formRate +
        FormStyleConstants.FORM_MANAGER_RECOMMEND_TITLE + FormStyleConstants.DEFAULT_FORM_MARGIN;
    }
    return card4x4HeightInner;
  }

  /**
   * 获取卡片网格宽度
   *
   * @returns 卡片网格宽度
   */
  public static getGridWidth(): number {
    const customGridWidth: number = FormCenterViewModel.getInstance().customGridWidth;
    // 优先使用卡片使用方传递的网格宽度
    if (customGridWidth > 0) {
      return customGridWidth;
    } else {
      const isScreenVertical: boolean = SCBScreenSessionManager.getInstance().isScreenVertical();
      return clockLayoutHelper.getLayoutGridWidth(isScreenVertical);
    }
  }
}