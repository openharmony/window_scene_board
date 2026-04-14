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
import { RectInfo } from '@ohos/basicutils/src/main/ets/utils/RectInfo';
import { RTLUtil } from '@ohos/componenthelper/src/main/ets/utils/RTLUtil';

/**
 * 卡片缩放类型
 */
export enum CardScaleType {

  /**
   * 水平垂直居中缩放
   */
  SCALE_CENTER = 0,
  /**
   * 垂直居中缩放
   */
  SCALE_VERTICAL_CENTER = 1,
  /**
   * 左上角缩放
   */
  SCALE_TOP_LEFT = 2,
  /**
   * 垂直居中缩放(相对于自身)
   */
  SCALE_VERTICAL_CENTER_SELF = 3,
}

/**
 * 通知卡片、实况卡片缩放工具类
 */
export class CardScaleUtil {
  /**
   * 界面缩放比例
   */
  public static readonly CARD_SCALE_RATE: number = 0.9;
  /**
   * 界面放大倍数(纯数字)
   */
  public static readonly CARD_ZOOM_IN_RATE_NUMBER: number = 1.11;
  /**
   * 界面放大倍数(百分比)
   */
  public static readonly CARD_ZOOM_IN_RATE_PERCENT: string = '111%';
  /**
   * 左上角缩放
   */
  public static readonly CARD_SCALE_LEFT_TOP: ScaleOptions = {
    x: CardScaleUtil.CARD_SCALE_RATE,
    y: CardScaleUtil.CARD_SCALE_RATE,
    centerX: '0%',
    centerY: '0%'
  };
  /**
   * 水平垂直居中缩放
   */
  public static readonly CARD_SCALE_CENTER: ScaleOptions = {
    x: CardScaleUtil.CARD_SCALE_RATE,
    y: CardScaleUtil.CARD_SCALE_RATE,
    centerX: '50%',
    centerY: '50%'
  };
  /**
   * 垂直居中缩放
   */
  public static readonly CARD_SCALE_VERTICAL_CENTER: ScaleOptions = {
    x: CardScaleUtil.CARD_SCALE_RATE,
    y: CardScaleUtil.CARD_SCALE_RATE,
    centerX: '0%',
    centerY: '50%'
  };

  /**
   * 顶部居中缩放
   */
  public static readonly CARD_SCALE_TOP_CENTER: ScaleOptions = {
    x: CardScaleUtil.CARD_SCALE_RATE,
    y: CardScaleUtil.CARD_SCALE_RATE,
    centerX: '50%',
    centerY: '0%'
  };

  /**
   * 垂直居中缩放
   */
  private static readonly CARD_SCALE_VERTICAL_CENTER_RTL: ScaleOptions = {
    x: CardScaleUtil.CARD_SCALE_RATE,
    y: CardScaleUtil.CARD_SCALE_RATE,
    centerX: '100%',
    centerY: '50%'
  };

  private static readonly ONE_HUNDRED_PERCENT: string = '100%';

  /**
   * 获取卡片宽度
   * @param needScale     卡片是否需要缩放, 若需要缩放则按比例放大宽度
   * @param originWidth   卡片原始宽度
   * @returns 返回修正后的卡片宽度
   */
  public static getWidth(needScale: boolean, originWidth: string | number | undefined): string | number | undefined {
    if (needScale) {
      if (originWidth === undefined || originWidth === this.ONE_HUNDRED_PERCENT) {
        return this.CARD_ZOOM_IN_RATE_PERCENT;
      } else if (typeof originWidth === 'number') {
        return originWidth * this.CARD_ZOOM_IN_RATE_NUMBER;
      } else {
        return originWidth;
      }
    } else {
      return originWidth;
    }
  }

  /**
   * 获取卡片高度
   * @param needScale     卡片是否需要缩放, 若需要缩放则按比例放大高度
   * @param originHeight  卡片原始高度
   * @returns 返回修正后的卡片高度
   */
  public static getHeight(needScale: boolean, originHeight: string | number | undefined): string | number | undefined {
    if (needScale) {
      if (originHeight === undefined || originHeight === this.ONE_HUNDRED_PERCENT) {
        return this.CARD_ZOOM_IN_RATE_PERCENT;
      } else if (typeof originHeight === 'number') {
        return originHeight * this.CARD_ZOOM_IN_RATE_NUMBER;
      } else {
        return originHeight;
      }
    } else {
      return originHeight;
    }
  }

  /**
   * 获取圆角半径
   * @param needScale     卡片是否需要绽放
   * @param originRadius  原始radius值
   * @returns 返回radius
   */
  public static getRadius(needScale: boolean, originRadius: number): number {
    if (needScale) {
      return originRadius * this.CARD_ZOOM_IN_RATE_NUMBER;
    } else {
      return originRadius;
    }
  }

  /**
   * 获取缩放参数
   * @param needScale       卡片是否需要缩放
   * @param type            缩放类型
   * @returns 返回缩放参数
   */
  public static getScale(needScale: boolean, type: CardScaleType): ScaleOptions {
    if (needScale) {
      switch (type) {
        case CardScaleType.SCALE_VERTICAL_CENTER:
          return this.CARD_SCALE_VERTICAL_CENTER;
        case CardScaleType.SCALE_TOP_LEFT:
          return this.CARD_SCALE_LEFT_TOP;
        case CardScaleType.SCALE_VERTICAL_CENTER_SELF:
          return RTLUtil.isRTL() ? this.CARD_SCALE_VERTICAL_CENTER_RTL : this.CARD_SCALE_VERTICAL_CENTER;
        default:
          return this.CARD_SCALE_CENTER;
      }
    } else {
      return undefined;
    }
  }

  /**
   * 缩放矩形坐标信息
   * @param   rectInfo  待处理的矩形坐标信息
   */
  public static scaleRect(rectInfo: RectInfo): RectInfo {
    // 宽度进行缩放
    let width = rectInfo.width ?? rectInfo.right - rectInfo.left;
    width = width * this.CARD_SCALE_RATE;

    // 更新矩形坐标信息
    rectInfo.width = width;
    if (RTLUtil.isRTL()) {
      rectInfo.left = rectInfo.right - rectInfo.width;
    } else {
      rectInfo.right = rectInfo.left + rectInfo.width;
    }
    return rectInfo;
  }
}