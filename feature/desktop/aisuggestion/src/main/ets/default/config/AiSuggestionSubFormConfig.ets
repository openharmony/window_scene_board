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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { FormViewModel } from '@ohos/form';
import { FormComponentConfig } from '@ohos/launchercommon/src/main/ets/form/model/FormComponentConfig';

/**
 * 母卡片属性
 *
 * @since 2025-03-19
 */
export interface ParentFormAttr {
  /**
   * 尺寸
   */
  dimension: number;

  /**
   * 宽度
   */
  width: number;

  /**
   * 高度
   */
  height: number;

  /**
   * 内边距
   */
  gridPadding: number;

  /**
   * 列间距
   */
  columnsGap: number;

  /**
   * 行间距
   */
  rowsGap: number;

  /**
   * 标题区高度
   */
  titleHeight: number;

  /**
   * 行数
   */
  rows: number;

  /**
   * 列数
   */
  columns: number;

  /**
   * 是否外屏
   */
  isOuterDesktop: boolean;
}

/**
 * 子卡片属性
 *
 * @since 2025-03-19
 */
export interface ChildFormAttr {
  /**
   * 尺寸
   */
  dimension: number;
}

/**
 * layoutSize * displayRate = realLayoutSize
 *
 * @since 2025-03-19
 */
interface SubFormDisplayStyle {
  /**
   * 布局大小
   */
  layoutSize: Size;

  /**
   * 缩放比例
   */
  displayRate: number;
}

const TAG = 'AiSuggestionSubFormConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 语音助手建议子卡片配置
 *
 * @since 2025-03-19
 */
export class AiSuggestionSubFormConfig {
  private mDisplayStyle?: SubFormDisplayStyle;

  /**
   * 构造方法
   *
   * @param parentAttr 母卡片属性
   * @param childAttr 子卡片属性
   */
  public constructor(parentAttr: ParentFormAttr, childAttr: ChildFormAttr) {
    if (!parentAttr || !childAttr) {
      log.showWarn('input params is invalid');
      return;
    }
    this.mDisplayStyle = this.getDisplayStyle(parentAttr, childAttr);
  }

  /**
   * 获取子卡布局缩放系数
   *
   * @returns 缩放系数
   */
  public getSubFormLayoutScale(): ScaleOptions {
    return { x: this.mDisplayStyle?.displayRate ?? 1, y: this.mDisplayStyle?.displayRate ?? 1};
  }

  /**
   * 获取子卡布局大小
   *
   * @returns 布局大小
   */
  public getSubFormLayoutSize(): Size {
    return this.mDisplayStyle?.layoutSize ?? { width: 0, height: 0 };
  }

  private calcLayoutSize(parentAttr: ParentFormAttr, childAttr: ChildFormAttr): Size {
    if (parentAttr.dimension === FormDimension.Dimension_2_2) {
      return this.calc2X2LayoutSize(parentAttr, childAttr);
    }
    if (parentAttr.dimension === FormDimension.Dimension_2_4) {
      return this.calc2X4LayoutSize(parentAttr, childAttr);
    }
    if (parentAttr.dimension === FormDimension.Dimension_4_4) {
      return this.calc4X4LayoutSize(parentAttr, childAttr);
    }
    log.showWarn(`calcLayoutSize unknown parent dimension = ${parentAttr.dimension}`);
    return { width: 0, height: 0 };
  }

  private calc4X4LayoutSize(parentAttr: ParentFormAttr, childAttr: ChildFormAttr): Size {
    const layoutSize: Size = { width: 0, height: 0 };
    if (childAttr.dimension === FormDimension.Dimension_1_2) {
      // 4x4尺寸，推荐1x2卡片
      // 实际布局宽度 = （母卡片宽度 - 内边距 * 2 - 列间距） / 2
      layoutSize.width = (parentAttr.width - (parentAttr.gridPadding * 2) - parentAttr.columnsGap) / 2;
      layoutSize.height = this.calc1X2ChildIn4X4(parentAttr);
    } else if (childAttr.dimension === FormDimension.Dimension_2_2) {
      // 4x4尺寸，推荐2x2卡片
      // 实际布局宽度 = （母卡片宽度 - 内边距 * 2 - 列间距） / 2
      // 实际布局高度 = 1x2卡片高度 * 2 + 行间距
      layoutSize.width = (parentAttr.width - (parentAttr.gridPadding * 2) - parentAttr.columnsGap) / 2;
      layoutSize.height = this.calc1X2ChildIn4X4(parentAttr) * 2 + parentAttr.rowsGap;
    } else if (childAttr.dimension == FormDimension.Dimension_2_4) {
      // 4x4尺寸，推荐2x4卡片
      // 实际布局宽度 = 母卡片宽度 - 内边距 * 2
      // 实际布局高度 = 1x2卡片高度 * 2 + 行间距
      layoutSize.width = parentAttr.width - (parentAttr.gridPadding * 2);
      layoutSize.height = this.calc1X2ChildIn4X4(parentAttr) * 2 + parentAttr.rowsGap;
    } else {
      // 4x4尺寸，推荐4x4卡片，实际布局宽高 = 母卡片宽高
      layoutSize.width = parentAttr.width;
      layoutSize.height = parentAttr.height;
    }
    return layoutSize;
  }

  private calc1X2ChildIn4X4(parentAttr: ParentFormAttr): number {
    // 4x4尺寸，推荐1x2卡片实际布局高度计算
    // 实际布局高度 = （母卡片高度 - blank占位高度 - 内边距 * 2 - 行间距 * 间距行数） / 行数
    return (parentAttr.height - parentAttr.titleHeight - (parentAttr.gridPadding * 2) -
      (parentAttr.rowsGap * (parentAttr.rows - 1))) / parentAttr.rows;
  }

  private calc2X4LayoutSize(parentAttr: ParentFormAttr, childAttr: ChildFormAttr): Size {
    const layoutSize: Size = { width: 0, height: 0 };
    if (childAttr.dimension === FormDimension.Dimension_1_2) {
      // 2x4尺寸，推荐1x2卡片
      // 实际布局宽度 = （母卡片宽度 - 内边距 * 2 - 列间距） / 2
      // 实际布局高度 = （母卡片高度 - 内边距 * 2 - 行间距）/ 2
      layoutSize.width = (parentAttr.width - (parentAttr.gridPadding * 2) - parentAttr.columnsGap) / 2;
      layoutSize.height = (parentAttr.height - (parentAttr.gridPadding * 2) - parentAttr.rowsGap) / 2;
    } else if (childAttr.dimension === FormDimension.Dimension_2_2) {
      // 2x4尺寸，推荐2x2卡片
      // 实际布局宽度 = （母卡片宽度 - 内边距 * 2 - 列间距） / 2
      // 实际布局高度 = 母卡片高度 - 内边距 * 2
      layoutSize.width = (parentAttr.width - (parentAttr.gridPadding * 2) - parentAttr.columnsGap) / 2;
      layoutSize.height = parentAttr.height - (parentAttr.gridPadding * 2);
    } else {
      // 2x4尺寸，推荐2x4卡片，实际布局宽高 = 母卡片宽高
      layoutSize.width = parentAttr.width;
      layoutSize.height = parentAttr.height;
    }
    return layoutSize;
  }

  private calc2X2LayoutSize(parentAttr: ParentFormAttr, childAttr: ChildFormAttr): Size {
    const layoutSize: Size = { width: 0, height: 0 };
    if (childAttr.dimension === FormDimension.Dimension_1_2) {
      // 2x2尺寸，推荐1x2卡片
      // 实际布局宽度 = 母卡片宽度 - 内边距 * 2
      // 实际布局高度 = （母卡片高度 - 标题栏高度 - 内边距 * 2 - 行间距）/ 2
      layoutSize.width = parentAttr.width - (parentAttr.gridPadding * 2);
      layoutSize.height =
        (parentAttr.height - parentAttr.titleHeight - (parentAttr.gridPadding * 2) - parentAttr.rowsGap) / 2;
    } else {
      // 2x2尺寸，推荐2x2卡片，实际布局宽高 = 母卡片宽高
      layoutSize.width = parentAttr.width;
      layoutSize.height = parentAttr.height;
    }
    return layoutSize;
  }

  private getDisplayStyle(parentAttr: ParentFormAttr, childAttr: ChildFormAttr): SubFormDisplayStyle {
    // 计算子卡片实际在母卡片内的布局宽高
    const layoutSize = this.calcLayoutSize(parentAttr, childAttr);
    const style: SubFormDisplayStyle = {
      layoutSize: layoutSize,
      displayRate: 1
    };
    if (CheckEmptyUtils.isEmpty(layoutSize) || layoutSize.width === 0 || layoutSize.height === 0) {
      log.showWarn('getDisplayStyle input params is invalid');
      return style;
    }

    log.showInfo(`getDisplayStyle: ${parentAttr.dimension}_${childAttr.dimension}, ${parentAttr.isOuterDesktop},` +
      ` parentAttr: [${parentAttr.width}x${parentAttr.height}], titleHeight: ${parentAttr.titleHeight},` +
      ` gridAttr: ${parentAttr.gridPadding}_${parentAttr.rowsGap}_${parentAttr.columnsGap}_${parentAttr.rows}_${parentAttr.columns},` +
      ` layoutSize = [${layoutSize.width}x${layoutSize.height}]`);

    if (parentAttr.isOuterDesktop) {
      const outerDesktopDisplayStyle =
        FormComponentConfig.getInstance().getFormComponentDisplayStyle(childAttr.dimension, layoutSize);
      style.layoutSize = outerDesktopDisplayStyle.formLayoutSize as Size;
      style.displayRate = outerDesktopDisplayStyle.displayRate;
      return style;
    }

    // 获取桌面卡片标准宽高
    const formStyleConfig = FormViewModel.getInstance().getFormStyleConfig();
    const desktopFormSize: Size = {
      width: formStyleConfig?.mFormWidth?.get(childAttr.dimension.toString()) ?? 0,
      height: formStyleConfig?.mFormHeight?.get(childAttr.dimension.toString()) ?? 0
    };

    // 计算标准宽高与实际布局宽高的变化比例
    const widthRate: number = desktopFormSize.width / layoutSize.width;
    const heightRate: number = desktopFormSize.height / layoutSize.height;
    log.showInfo(`getDisplayStyle: desktopFormSize = [${desktopFormSize.width}x${desktopFormSize.height}]`);

    style.layoutSize = desktopFormSize;
    if (widthRate > heightRate) {
      style.layoutSize.height = layoutSize.height * widthRate;
      style.displayRate = 1 / widthRate;
    } else {
      style.layoutSize.width = layoutSize.width * heightRate;
      style.displayRate = 1 / heightRate;
    }
    log.showInfo(`getDisplayStyle: [${style.layoutSize.width}x${style.layoutSize.height}], r${style.displayRate}`);
    return style;
  }
}
