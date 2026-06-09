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

import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ClockWidgetId, ClockLayout } from '../../common/WidgetParam';
import { ClockGridParam, ElementConf, ElementHorAlign, ElementVerAlign } from './ClockLayoutParam';
import { common2D } from '@kit.ArkGraphics2D';
import { clockTextBoundHelper } from './ClockTextBoundHelper';
import { DateWeekLunarModifier } from './DateWeekLunarModifier';
import { ClockBindData } from '../model/data/ClockBindData';

const TAG = 'ClockLayoutModifier';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 时钟布局动态调整类，主要是根据不同字体的可视区域不同，动态调整时钟文字的大小、位置，满足设计的同时避免截断、重叠
 */
export class ClockLayoutModifier {
  // 可视区域在父布局中的位置
  private visibleRectsInParent: common2D.Rect[] = [];
  // 最终显示大小对应的中框
  private finalMiddleBounds: Map<ClockWidgetId, common2D.Rect | undefined> = new Map();
  // 最大外框，单位是px
  private maxOuterBound: common2D.Rect | undefined = undefined;
  private enable: boolean = false;
  private lastTimeFontFamily: string = '';
  private lastLayout: ClockLayout | undefined = undefined;
  private dateWeekLunarModifier: DateWeekLunarModifier

  constructor(bindState: ClockBindData) {
    this.dateWeekLunarModifier = new DateWeekLunarModifier(bindState);
  }

  /**
   * 更新日期、星期、农历数据
   * @param dateStr 日期
   * @param bigDateStr 日期
   * @param weekStr 星期
   * @param lunarDate 农历
   */
  public updateDateWeekLunarStr(dateStr: ResourceStr, bigDateStr: ResourceStr, weekStr: ResourceStr,
    lunarDate: string) {
    this.dateWeekLunarModifier.updateDateWeekLunarStr(dateStr, bigDateStr, weekStr, lunarDate);
  }



  /**
   * 调整时钟元素布局
   * @param timeElements 待调整的时钟元素
   * @param gridParam 时钟网格等参数
   * @param timeFontFamily 字体
   */
  public modifyLayout(timeElements: ElementConf[], dateWeekLunarElements: ElementConf[],
    gridParam: ClockGridParam) {
    if (!this.enable) {
      log.showInfo('ClockLayoutModifier is not enable');
      return;
    }

  }

  private modifyClockLayout(timeFontFamily: string, timeElements: ElementConf[], gridParam: ClockGridParam) {
    let middleBounds = this.preMeasure(timeElements, timeFontFamily);
    if (middleBounds.size === 0) {
      log.showInfo('middleBounds is empty.')
      return;
    }

    this.finalMiddleBounds = this.modifyFontsize(timeElements, middleBounds);

    this.maxOuterBound = this.computeMaxOuterBound(timeElements, timeFontFamily);

    let parent = new ElementConf();
    parent.id = ClockWidgetId.ID_PARENT;
    parent.width = gridParam.gridWidthSize;
    parent.height = gridParam.gridHeightSize;
    timeElements.push(parent);
    this.modifyPosition(timeElements, this.finalMiddleBounds);

    // 返回文字可视区域在父布局中的位置及大小
    this.visibleRectsInParent = this.computeVisibleRectInParent(timeElements, this.finalMiddleBounds);
    log.showDebug(`update visibleRectsInParent length ${this.visibleRectsInParent.length}`);
  }

  private computeVisibleRectInParent(timeElements: ElementConf[],
    middleBounds: Map<ClockWidgetId, common2D.Rect | undefined>): common2D.Rect[] {
    let visibleRectsInParent: common2D.Rect[] = [];
    for (let index = 0; index < timeElements.length; index++) {
      let middleBound = middleBounds.get(timeElements[index].id);
      if (middleBound) {
        let width = middleBound.right - middleBound.left;
        // 这里需要审视通过anchor计算偏移量时，应用用中框，还是用外框
        let positionX = timeElements[index].offset.x as number -
          this.computeDeltaX(width, timeElements[index].anchor.x);
        let positionY = timeElements[index].offset.y as number;
        visibleRectsInParent.push({
          left: positionX + middleBound.left,
          top: positionY + middleBound.top,
          right: positionX + middleBound.right,
          bottom: positionY + middleBound.bottom
        })
      }
    }

    log.showInfo(`visibleRectsInParent length ${visibleRectsInParent.length}`);
    return visibleRectsInParent;
  }

  private computeMaxOuterBound(timeElements: ElementConf[], timeFontFamily: string | undefined):
    common2D.Rect | undefined {
    if (timeFontFamily && timeElements.length > 0) {
      let maxOuterBoundVp = clockTextBoundHelper.getMaxOuterBound(timeFontFamily, timeElements[0].fontSize);
      if (maxOuterBoundVp) {
        return {
          left: vp2px(maxOuterBoundVp.left),
          top: vp2px(maxOuterBoundVp.top),
          right: vp2px(maxOuterBoundVp.right),
          bottom: vp2px(maxOuterBoundVp.bottom),
        };
      }
    }

    return undefined;
  }

  private preMeasure(timeElements: ElementConf[], timeFontFamily?: string):
    Map<ClockWidgetId, common2D.Rect | undefined> {
    let middleBounds: Map<ClockWidgetId, common2D.Rect | undefined> = new Map();
    if (!timeFontFamily) {
      return middleBounds;
    }

    timeElements.forEach((conf) => {
      if (!conf.needModifyProperties) {
        return;
      }

      let middleBound = clockTextBoundHelper.getMaxMiddleBound(timeFontFamily, conf.fontSize);
      if (middleBound && conf.id === ClockWidgetId.ID_SEPARATOR) { // 分隔符的宽度不一样
        let separatorInnerBound = clockTextBoundHelper.getMiddleBound(timeFontFamily, ':', conf.fontSize);
        if (separatorInnerBound) {
          middleBound.left = separatorInnerBound.left;
          middleBound.right = separatorInnerBound.right;
        }
      }

      middleBounds.set(conf.id, middleBound);
    });

    return middleBounds;
  }

  private modifyFontsize(timeElements: ElementConf[], middleBounds:
    Map<ClockWidgetId, common2D.Rect | undefined>): Map<ClockWidgetId, common2D.Rect | undefined> {
    let finalMiddleBounds: Map<ClockWidgetId, common2D.Rect | undefined> = new Map();
    if (middleBounds.size == 0) {
      return finalMiddleBounds;
    }

    let minScale = 1;
    timeElements.forEach((conf) => {
      let middleBound = middleBounds.get(conf.id);
      if (!conf.height || !middleBound || !conf.needModifyProperties) {
        return;
      }

      let middleHeight = middleBound.bottom - middleBound.top;
      if (!middleHeight) {
        return;
      }

      let middleWidth = middleBound.right - middleBound.left;
      let scale = conf.height / middleHeight
      conf.fontSize *= scale;
      conf.width = middleWidth * scale;
      if (conf.maxWidth && conf.width > 0) {
        let tmpScale = conf.maxWidth / conf.width;
        // 如果元素超过设定的最大宽度，记录更小的缩小系数
        minScale = Math.min(tmpScale, minScale);
      }

      finalMiddleBounds.set(
        conf.id,
        {
          left: middleBound.left * scale,
          right: middleBound.right * scale,
          top: middleBound.top * scale,
          bottom: middleBound.bottom * scale
        });
    });

    // 如果元素超过设定的最大宽度，需要进行缩小，放置重叠、截断
    if (minScale < 1) {
      timeElements.forEach((conf) => {
        conf.fontSize *= minScale;
        conf.width = conf.width ? conf.width * minScale : conf.width;
      });
      finalMiddleBounds.forEach((bound) => {
        if (bound) {
          bound.left *= minScale;
          bound.right *= minScale;
          bound.top *= minScale;
          bound.bottom *= minScale;
        }
      });
    }

    return finalMiddleBounds;
  }

  private modifyPosition(timeElements: ElementConf[],
    middleBounds: Map<ClockWidgetId, common2D.Rect | undefined>): void {
    let timeElementsMap:Map<ClockWidgetId, ElementConf> = new Map();
    timeElements.forEach((conf) => {
      timeElementsMap.set(conf.id, conf);
    });

    this.modifyPositionX(timeElements, timeElementsMap);

    this.modifyPositionY(timeElements, timeElementsMap, middleBounds);
  }

  private modifyPositionY(timeElements: ElementConf[], timeElementsMap: Map<ClockWidgetId, ElementConf>,
    middleBounds: Map<ClockWidgetId, common2D.Rect | undefined>) {
    let eleToModifyHorPos: ElementConf[] = [];
    timeElements.forEach((conf) => {
      if (!conf.horReMargin?.alignTargetId || !conf.horReMargin?.alignSelf || !conf.horReMargin?.alignTarget) {
        return;
      }

      eleToModifyHorPos.push(conf);
      let targetElement = timeElementsMap.get(conf.horReMargin?.alignTargetId);
      while (targetElement && targetElement.horReMargin?.alignTargetId &&
        eleToModifyHorPos.length < timeElements.length) {
        eleToModifyHorPos.push(targetElement);
        targetElement = timeElementsMap.get(targetElement.horReMargin?.alignTargetId);
      }
      if (!targetElement) {
        return;
      }

      do {
        let sourceElement = eleToModifyHorPos.pop();
        if (!sourceElement) {
          break;
        }

        // 要考虑offset.y可能为百分数的情况
        let finalY = targetElement.offset.y as number + (sourceElement.horReMargin?.margin ?? 0);
        if (sourceElement.horReMargin?.alignSelf == ElementHorAlign.TOP &&
          sourceElement.horReMargin?.alignTarget == ElementHorAlign.TOP) {
          finalY += 0;
        } else if (sourceElement.horReMargin?.alignSelf == ElementHorAlign.TOP &&
          sourceElement.horReMargin?.alignTarget == ElementHorAlign.CENTER) {
          finalY += (targetElement.height ?? 0) / 2;
        } else if (sourceElement.horReMargin?.alignSelf == ElementHorAlign.TOP &&
          sourceElement.horReMargin?.alignTarget == ElementHorAlign.BOTTOM) {
          finalY += (targetElement.height ?? 0);
        } else if (sourceElement.horReMargin?.alignSelf == ElementHorAlign.CENTER &&
          sourceElement.horReMargin?.alignTarget == ElementHorAlign.TOP) {
          finalY += - (sourceElement.height ?? 0) / 2;
        } else if (sourceElement.horReMargin?.alignSelf == ElementHorAlign.CENTER &&
          sourceElement.horReMargin?.alignTarget == ElementHorAlign.CENTER) {
          finalY += (targetElement.height ?? 0) / 2 - (sourceElement.height ?? 0) / 2;
        } else if (sourceElement.horReMargin?.alignSelf == ElementHorAlign.CENTER &&
          sourceElement.horReMargin?.alignTarget == ElementHorAlign.BOTTOM) {
          finalY += (targetElement.height ?? 0) - (sourceElement.height ?? 0) / 2;
        } else if (sourceElement.horReMargin?.alignSelf == ElementHorAlign.BOTTOM &&
          sourceElement.horReMargin?.alignTarget == ElementHorAlign.TOP) {
          finalY += - (sourceElement.height ?? 0);
        } else if (sourceElement.horReMargin?.alignSelf == ElementHorAlign.BOTTOM &&
          sourceElement.horReMargin?.alignTarget == ElementHorAlign.CENTER) {
          finalY += (targetElement.height ?? 0) / 2 - (sourceElement.height ?? 0);
        } else if (sourceElement.horReMargin?.alignSelf == ElementHorAlign.BOTTOM &&
          sourceElement.horReMargin?.alignTarget == ElementHorAlign.BOTTOM) {
          finalY += (targetElement.height ?? 0) - (sourceElement.height ?? 0);
        }

        sourceElement.offset = { x: sourceElement.offset.x, y: finalY };
        if (sourceElement.horReMargin) {
          sourceElement.horReMargin.alignTargetId = undefined; // 标识该元素的竖向位置已经确定
        }
        targetElement = sourceElement;
      } while (eleToModifyHorPos.length > 0);
    });

    // 上述计算finalY是考虑的中框区域，但最终Text布局是以外框区域，所以要进行调整；就算没有上述计算，原始配置参数也需要进行调整
    timeElements.forEach((conf) => {
      let middleBound = middleBounds.get(conf.id);
      if (middleBound && CommonUtils.isNumber(conf.offset.y) && conf.height) {
        let middleHeight = middleBound.bottom - middleBound.top;
        if (middleHeight > 0) {
          conf.offset.y = conf.offset.y as number - middleBound.top * (conf.height / middleHeight);
        }
      }
    });
  }

  private modifyPositionX(timeElements: ElementConf[], timeElementsMap: Map<ClockWidgetId, ElementConf>) {
    let eleToModifyVerPos: ElementConf[] = [];
    timeElements.forEach((conf) => {
      if (!conf.verReMargin?.alignTargetId || !conf.verReMargin?.alignSelf || !conf.verReMargin?.alignTarget) {
        return;
      }

      eleToModifyVerPos.push(conf);
      let targetElement = timeElementsMap.get(conf.verReMargin?.alignTargetId);
      while (targetElement && targetElement.verReMargin?.alignTargetId &&
        eleToModifyVerPos.length < timeElements.length) {
        eleToModifyVerPos.push(targetElement);
        targetElement = timeElementsMap.get(targetElement.verReMargin.alignTargetId);
      }

      do {
        let sourceElement = eleToModifyVerPos.pop();
        if (!sourceElement || !targetElement) {
          break;
        }

        // 要考虑offset.x可能为百分数的情况
        // 这里需要审视通过anchor计算偏移量时，应用用中框，还是用外框
        let finalX = targetElement.offset.x as number -
          this.computeDeltaX(targetElement.width, targetElement.anchor.x) + (sourceElement.verReMargin?.margin ?? 0);
        if (sourceElement.verReMargin?.alignSelf == ElementVerAlign.LEFT &&
          sourceElement.verReMargin?.alignTarget == ElementVerAlign.LEFT) {
          finalX += 0;
        } else if (sourceElement.verReMargin?.alignSelf == ElementVerAlign.LEFT &&
          sourceElement.verReMargin?.alignTarget == ElementVerAlign.CENTER) {
          finalX += (targetElement.width ?? 0) / 2;
        } else if (sourceElement.verReMargin?.alignSelf == ElementVerAlign.LEFT &&
          sourceElement.verReMargin?.alignTarget == ElementVerAlign.RIGHT) {
          finalX += (targetElement.width ?? 0);
        } else if (sourceElement.verReMargin?.alignSelf == ElementVerAlign.CENTER &&
          sourceElement.verReMargin?.alignTarget == ElementVerAlign.LEFT) {
          finalX += - (sourceElement.width ?? 0) / 2;
        } else if (sourceElement.verReMargin?.alignSelf == ElementVerAlign.CENTER &&
          sourceElement.verReMargin?.alignTarget == ElementVerAlign.CENTER) {
          finalX += (targetElement.width ?? 0) / 2 - (sourceElement.width ?? 0) / 2;
        } else if (sourceElement.verReMargin?.alignSelf == ElementVerAlign.CENTER &&
          sourceElement.verReMargin?.alignTarget == ElementVerAlign.RIGHT) {
          finalX += (targetElement.width ?? 0) - (sourceElement.width ?? 0) / 2;
        } else if (sourceElement.verReMargin?.alignSelf == ElementVerAlign.RIGHT &&
          sourceElement.verReMargin?.alignTarget == ElementVerAlign.LEFT) {
          finalX += - (sourceElement.width ?? 0);
        } else if (sourceElement.verReMargin?.alignSelf == ElementVerAlign.RIGHT &&
          sourceElement.verReMargin?.alignTarget == ElementVerAlign.CENTER) {
          finalX += (targetElement.width ?? 0) / 2 - (sourceElement.width ?? 0);
        } else if (sourceElement.verReMargin?.alignSelf == ElementVerAlign.RIGHT &&
          sourceElement.verReMargin?.alignTarget == ElementVerAlign.RIGHT) {
          finalX += (targetElement.width ?? 0) - (sourceElement.width ?? 0);
        }

        // 由于不同数字的Text外框宽度可能不一样，无法确定Text的横向坐标，只能确定其横向中心位置，因此anchor会配置为50%，需要根据anchor反向调整finalX
        finalX += this.computeDeltaX(sourceElement.width, sourceElement.anchor.x);

        sourceElement.offset = { x: finalX, y: sourceElement.offset.y };
        if (sourceElement.verReMargin) {
          sourceElement.verReMargin.alignTargetId = undefined; // 标识该元素的竖向位置已经确定
        }
        targetElement = sourceElement;
      } while (eleToModifyVerPos.length > 0);
    });
  }

  private computeDeltaX(width: number | undefined, anchorX: Length | undefined): number {
    if (CommonUtils.isNumber(anchorX)) {
      return anchorX as number;
    } else if (CommonUtils.isString(anchorX) && width) {
      let anchorXNum = Number.parseFloat((anchorX as string).replace('%', ''));
      return width * anchorXNum / 100;
    }

    return 0;
  }

  /**
   * 获取时钟大小位置调节后，对应的中框
   * @returns 中框
   */
  public getFinalMiddleBoundPx(): common2D.Rect | undefined {
    let finalMiddleBound = this.finalMiddleBounds.get(ClockWidgetId.ID_HOUR0);
    if (!finalMiddleBound) {
      return undefined;
    }

    return {
      left: vp2px(finalMiddleBound.left),
      top: vp2px(finalMiddleBound.top),
      right: vp2px(finalMiddleBound.right),
      bottom: vp2px(finalMiddleBound.bottom)
    }
  }

  public getMaxOuterBound(): common2D.Rect | undefined {
    return this.maxOuterBound;
  }

  /**
   * 获取艺术文字的可视区域在父布局中的位置和大小
   * @returns 返回可视区域数组
   */
  public getVisibleRectsInParent(): common2D.Rect[] {
    return this.visibleRectsInParent;
  }

  /**
   * 计算日期、星期、农历元素布局
   * @param elements 待调整的时钟元素
   * @param gridParam 时钟网格等参数
   * @param timeFontFamily 字体
   */
  public modifyDateWeekLunarLayout(timeFontFamily: string, elements: ElementConf[], gridParam: ClockGridParam) {
    this.dateWeekLunarModifier.modifyDateWeekLunarLayout(elements, timeFontFamily, gridParam);
    this.visibleRectsInParent = this.visibleRectsInParent.concat(this.dateWeekLunarModifier.getVisibleRectsInParent());
  }
}