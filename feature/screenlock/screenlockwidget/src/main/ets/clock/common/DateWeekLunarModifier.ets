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
import { ClockWidgetId } from '../../common/WidgetParam';
import { ClockBuilderStyle, ElementConf, ClockGridParam, DEFAULT_MERGE_MARGIN } from './ClockLayoutParam';
import { common2D } from '@kit.ArkGraphics2D';
import { ClockBindData } from '../model/data/ClockBindData';

const TAG = 'DateWeekLunarModifier';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 时钟布局动态调整类，主要是根据不同字体的可视区域不同，动态调整日期、星期、农历文字的大小、位置，满足设计的同时避免截断、重叠
 */
export class DateWeekLunarModifier {
  private static ELEMENT_IDS: ClockWidgetId[] = [ClockWidgetId.ID_DATE, ClockWidgetId.ID_WEEK, ClockWidgetId.ID_LUNA];
  // 可视区域在父布局中的位置
  private visibleRectsInParentMap: Map<ClockWidgetId[], common2D.Rect>;
  // 时钟组件内部动态状态统一管理
  private bindState: ClockBindData;
  private fontFamily?: string;
  private gridParam?: ClockGridParam;
  private dateStr: ResourceStr = '';
  private bigDateStr: ResourceStr = '';
  private strMap: Map<ClockWidgetId, string>;
  private outerBoundMap: Map<ClockWidgetId, common2D.Rect | undefined>;

  constructor(bindState: ClockBindData) {
    this.bindState = bindState;
    this.outerBoundMap = new Map();
    this.strMap = new Map();
    this.visibleRectsInParentMap = new Map();
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
    this.dateStr = dateStr;
    this.bigDateStr = bigDateStr;
    this.strMap.set(ClockWidgetId.ID_WEEK, weekStr.toString());
    this.strMap.set(ClockWidgetId.ID_LUNA, lunarDate.toString());
  }

  private measureDateWeekLunar(elementMap: Map<ClockWidgetId, ElementConf>): void {
    let dateStr = this.bindState.isShowLargeDate ? this.bigDateStr ?? '' : this.dateStr ?? '';
    this.strMap.set(ClockWidgetId.ID_DATE, dateStr.toString());

    DateWeekLunarModifier.ELEMENT_IDS.forEach((id) => {
      let elementConf = elementMap.get(id);
      if (!elementConf) {
        return;
      }
      let outerBound = this.computeOuterBound(elementMap.get(id), this.strMap.get(id));
      this.outerBoundMap.set(id, outerBound);
    })
  }

  /**
   * 调整日期、星期、农历元素布局
   * @param elementConfs 待调整的元素
   * @param fontFamily 字体
   * @param gridParam 网格参数
   */
  public modifyDateWeekLunarLayout(elementConfs: ElementConf[], fontFamily: string, gridParam: ClockGridParam): void {
    log.showInfo('modify layout of date, week and lunar.');
    this.visibleRectsInParentMap.clear();
    this.fontFamily = fontFamily;
    this.gridParam = gridParam;
    let elementMap: Map<ClockWidgetId, ElementConf> = new Map();
    elementConfs.forEach(elementConf => {
      elementMap.set(elementConf.id, elementConf);
    })
    // 初步测量日期、星期、农历的大小
    this.measureDateWeekLunar(elementMap);

    if (this.bindState.isDateSeparatorStyle()) {
      this.modifySeparateLineTimeView(elementMap);
    } else if (this.bindState.isDateSingleLineStyle()) {
      let mergerOffset = elementMap.get(ClockWidgetId.ID_DATE)?.offset;
      let mergerAnchor = elementMap.get(ClockWidgetId.ID_DATE)?.anchor;
      let visibleMergeRect = this.modifyMergeView({isMergeDate: true, isMergeWeek: true, isMergeLunar: true},
        mergerOffset, mergerAnchor);
      if (visibleMergeRect) {
        this.visibleRectsInParentMap.set([ClockWidgetId.ID_DATE, ClockWidgetId.ID_WEEK, ClockWidgetId.ID_LUNA],
          visibleMergeRect);
      }
    } else {
      this.modifyMultiLineTimeView(elementMap);
    }

    // 调整字号，保证日期、星期、农历的宽度在限制以内
    this.modifyDateWeekLunarFontSize(elementMap, gridParam);
  }

  private modifyDateWeekLunarFontSize(elementMap: Map<ClockWidgetId, ElementConf>, gridParam: ClockGridParam): void {
    let dateWeekLunarWidth = 0;
    let widthElementCount = 0;
    this.visibleRectsInParentMap.forEach((rect: common2D.Rect, ids: ClockWidgetId[]) => {
      let curWidth = rect.right - rect.left
      if (dateWeekLunarWidth < curWidth) {
        dateWeekLunarWidth = curWidth;
        widthElementCount = ids.length;
      }
    })

    if (gridParam.dateWeekLunarMaxWidth && dateWeekLunarWidth > gridParam.dateWeekLunarMaxWidth) {
      let mergeMargin = DEFAULT_MERGE_MARGIN * (widthElementCount - 1);
      let realWidthWithoutMargin = dateWeekLunarWidth - mergeMargin;
      let designMaxWidthWithoutMargin = gridParam.dateWeekLunarMaxWidth - mergeMargin;
      if (realWidthWithoutMargin > 0 && designMaxWidthWithoutMargin > 0) {
        let scale = designMaxWidthWithoutMargin / realWidthWithoutMargin;
        elementMap.forEach((elementConf) => {
          elementConf.fontSize *= scale;
        });

        this.visibleRectsInParentMap.forEach((rect) => {
          rect.left *= scale;
          rect.right *= scale;
          rect.top *= scale;
          rect.bottom *= scale;
        });
      }
    }
  }

  private modifySeparateLineTimeView(elementMap: Map<ClockWidgetId, ElementConf>): void {
    let dateOuterBound = this.outerBoundMap.get(ClockWidgetId.ID_DATE);
    let dateOuterBoundInParent = this.computeOuterBoundInParent(dateOuterBound,
      elementMap.get(ClockWidgetId.ID_DATE)?.offset, elementMap.get(ClockWidgetId.ID_DATE)?.anchor);
    if (dateOuterBoundInParent) {
      this.visibleRectsInParentMap.set([ClockWidgetId.ID_DATE], dateOuterBoundInParent);
    }

    if (this.bindState.isMergeWeekLunar) {
      let mergerOffset = elementMap.get(ClockWidgetId.ID_WEEK)?.offset;
      let mergerAnchor = elementMap.get(ClockWidgetId.ID_WEEK)?.anchor;
      let weekLunarBoundInParent = this.modifyMergeView({isMergeWeek: true, isMergeLunar: true},
        mergerOffset, mergerAnchor);
      if (weekLunarBoundInParent) {
        this.visibleRectsInParentMap.set([ClockWidgetId.ID_WEEK, ClockWidgetId.ID_LUNA], weekLunarBoundInParent);
      }
    } else {
      let weekOuterBound = this.outerBoundMap.get(ClockWidgetId.ID_WEEK);
      let weekOuterBoundInParent = this.computeOuterBoundInParent(weekOuterBound,
        elementMap.get(ClockWidgetId.ID_WEEK)?.offset, elementMap.get(ClockWidgetId.ID_WEEK)?.anchor);
      if (weekOuterBoundInParent) {
        this.visibleRectsInParentMap.set([ClockWidgetId.ID_WEEK], weekOuterBoundInParent);
      }

      let lunarOuterBound = this.outerBoundMap.get(ClockWidgetId.ID_LUNA);
      let lunarOuterBoundInParent = this.computeOuterBoundInParent(lunarOuterBound,
        elementMap.get(ClockWidgetId.ID_LUNA)?.offset, elementMap.get(ClockWidgetId.ID_LUNA)?.anchor);
      if (lunarOuterBoundInParent) {
        this.visibleRectsInParentMap.set([ClockWidgetId.ID_LUNA], lunarOuterBoundInParent);
      }
    }
  }

  private computeOuterBound(elementConf: ElementConf | undefined, textContent: string | undefined):
    common2D.Rect | undefined {
    if (!elementConf || !this.fontFamily || !textContent || !textContent.length) {
      log.warn(`modifyText failed because elementConf is ${elementConf} or fontFamily is ${this.fontFamily}, textContent is ${textContent}`);
      return undefined;
    }

    return undefined;
}

  private computeOuterBoundInParent(outerBound: common2D.Rect | undefined, offset: Position | undefined,
    anchor: Position | undefined): common2D.Rect | undefined {
    if (!outerBound) {
      log.showWarn(`computeOuterBoundInParent failed because outerBound is ${outerBound}`);
      return outerBound;
    }

    let outerBoundInParent: common2D.Rect = {
      left: outerBound.left,
      top: outerBound.top,
      right: outerBound.right,
      bottom: outerBound.bottom
    }

    if (offset) {
      this.modifyBoundByOffset(offset, outerBoundInParent);
    }
    if (anchor) {
      this.modifyBoundByAnchor(anchor, outerBoundInParent);
    }

    return outerBoundInParent;
  }

  private modifyBoundByAnchor(anchor: Position, outerBoundInParent: common2D.Rect): void {
    if (anchor.x) {
      let horDeltaByAnchor = this.computeDelta(outerBoundInParent.right - outerBoundInParent.left, anchor.x);
      outerBoundInParent.left -= horDeltaByAnchor;
      outerBoundInParent.right -= horDeltaByAnchor;
    }
    if (anchor.y) {
      let horDeltaByAnchor = this.computeDelta(outerBoundInParent.bottom - outerBoundInParent.top, anchor.y);
      outerBoundInParent.top -= horDeltaByAnchor;
      outerBoundInParent.bottom -= horDeltaByAnchor;
    }
  }

  private modifyBoundByOffset(offset: Position, outerBoundInParent: common2D.Rect): void {
    if (!this.gridParam) {
      log.showWarn(`modifyBoundByOffset failed because gridParam is ${this.gridParam}`);
      return;
    }

    if (offset.x) {
      let horDeltaByOffset = this.computeDelta(this.gridParam.gridWidthSize, offset.x);
      outerBoundInParent.left += horDeltaByOffset;
      outerBoundInParent.right += horDeltaByOffset;
    }
    if (offset.y) {
      let verDeltaByOffset = this.computeDelta(this.gridParam.gridHeightSize, offset.y);
      outerBoundInParent.top += verDeltaByOffset;
      outerBoundInParent.bottom += verDeltaByOffset;
    }
  }

  private computeDelta(widthOrHeight: number, xOrY: Length): number {
    if (CommonUtils.isNumber(xOrY)) {
      return xOrY as number;
    } else if (CommonUtils.isString(xOrY)) {
      let xOrYNum = Number.parseFloat((xOrY as string).replace('%', ''));
      return widthOrHeight * xOrYNum / 100;
    }

    return 0;
  }

  /**
   * 调整合并为一行的日期、星期、农历等元素，元素之前的间隔距离为DEFAULT_MERGE_MARGIN
   * @param timeFontFamily
   * @param clockBuilderStyle
   */
  private modifyMergeView(clockBuilderStyle: ClockBuilderStyle,
    mergerOffset?: Position, mergerAnchor?: Position): common2D.Rect | undefined {
    let rectMerged: common2D.Rect | undefined = undefined;
    if (clockBuilderStyle.isMergeDate) {
      rectMerged = this.mergeRect(rectMerged, this.outerBoundMap.get(ClockWidgetId.ID_DATE));
    }

    if (clockBuilderStyle.isMergeWeek) {
      rectMerged = this.mergeRect(rectMerged, this.outerBoundMap.get(ClockWidgetId.ID_WEEK));
    }

    if (clockBuilderStyle.isMergeLunar) {
      rectMerged = this.mergeRect(rectMerged, this.outerBoundMap.get(ClockWidgetId.ID_LUNA));
    }

    if (!rectMerged) {
      log.showWarn(`computeOuterBoundInParent failed because rectMerged is ${rectMerged}`);
      return undefined;
    }

    if (mergerOffset) {
      this.modifyBoundByOffset(mergerOffset, rectMerged);
    }
    if (mergerAnchor) {
      this.modifyBoundByAnchor(mergerAnchor, rectMerged);
    }

    return rectMerged;
  }

  private mergeRect(rect1: common2D.Rect | undefined, rect2: common2D.Rect | undefined): common2D.Rect | undefined {
    if (!rect1 || !rect2) {
      return rect1 !== undefined ? rect1 : rect2;
    }

    return {
      left: 0,
      top: Math.min(rect1.top, rect2.top),
      right: rect1.right + rect2.right + DEFAULT_MERGE_MARGIN,
      bottom: Math.max(rect1.bottom, rect2.bottom),
    }
  }

  private modifyMultiLineTimeView(elementMap: Map<ClockWidgetId, ElementConf>): void {
    let mergerOffset = elementMap.get(ClockWidgetId.ID_DATE)?.offset;
    let mergerAnchor = elementMap.get(ClockWidgetId.ID_DATE)?.anchor;
    let dateWeekBoundInParent = this.modifyMergeView({isMergeDate: true, isMergeWeek: true},
      mergerOffset, mergerAnchor);
    if (dateWeekBoundInParent) {
      this.visibleRectsInParentMap.set([ClockWidgetId.ID_DATE, ClockWidgetId.ID_WEEK], dateWeekBoundInParent);
    }

    let lunarOuterBound = this.outerBoundMap.get(ClockWidgetId.ID_LUNA);;
    let lunarOuterBoundInParent = this.computeOuterBoundInParent(lunarOuterBound,
      elementMap.get(ClockWidgetId.ID_LUNA)?.offset, elementMap.get(ClockWidgetId.ID_LUNA)?.anchor);
    if (lunarOuterBoundInParent) {
      this.visibleRectsInParentMap.set([ClockWidgetId.ID_LUNA], lunarOuterBoundInParent);
    }
  }

  /**
   * 获取艺术文字的可视区域在父布局中的位置和大小
   * @returns 返回可视区域数组
   */
  public getVisibleRectsInParent(): common2D.Rect[] {
    let visibleRectsInParent: common2D.Rect[] = [];
    this.visibleRectsInParentMap.forEach((rect) => {
      visibleRectsInParent.push(rect);
    });

    return visibleRectsInParent;
  }
}
