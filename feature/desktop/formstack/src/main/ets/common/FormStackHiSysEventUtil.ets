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

import { FormHiSysEventUtil } from '@ohos/form/src/main/ets/default/util/FormHiSysEventUtil';
import { ReportParams, ReportDomain, HiSysReportEvent, HiSysEventUtil } from '@ohos/frameworkwrapper';

const reporter: HiSysReportEvent = HiSysReportEvent.getHiSysReportEvent(ReportDomain.FORM_UE);
const outerReporter: HiSysReportEvent = HiSysReportEvent.getHiSysReportEvent(ReportDomain.OUTER_HOME_UE);

export interface FormStackCreateEvent {
  dragItemPackageName: string;
  endItemPackageName: string;
  formStackID: string;
  area: number[];
  screenPage: number;
  column: number;
  row: number;
  dragSourceType: string;
  overSourceType: string;
}

export interface FormStackAddCardEvent {
  dragItemPackageName: string;
  totalNum: number;
  formStackID: string;
  area: number[];
  screenPage: number;
  column: number;
  row: number;
  dragSourceType: string;
}

export interface SwitchCardsEvent {
  formStackID: string;
  area: number[];
  screenPage: number;
  column: number;
  row: number;
  topCardPackageName: string;
  slideType: SwitchCardsSlideType;
}

export enum SwitchCardsSlideType {
  SLIDE_DOWN = 1,
  SLIDE_UP,
}

export interface ShortcutMenuClickEvent {
  type: ShortcutMenuClickItem;
  formStackID: string;
  area: number[];
  topCardPackageName: string;
  sourceType?: string;
  //卡片类型，0-普通卡片 1-互动卡片-场景动效 2-互动卡片-趣味交互
  formType: number;
}

export enum ShortcutMenuClickItem {
  ITEM_NONE,
  ITEM_EDIT,
  ITEM_REMOVE,
  ITEM_EXPAND,
}

export interface FormStackMoveEvent {
  formStackID: string;
  area: number[];
  startPage: number;
  startColumn: number;
  startRow: number;
  endPage: number;
  endColumn: number;
  endRow: number;
  sourceType: string;
}

export interface FormStackClickEvent {
  formStackID: string;
  area: number[];
  topCardPackageName: string;
  sourceType?: string;
}

export interface FormStackExpandEventParam {
  formStackID: string;
  area: number[];
  page: number;
  column: number;
  row: number;
  cardNum: number;
}

export interface FormStackCollapseEvent {
  formStackID: string;
  area: number[];
  page: number;
  column: number;
  row: number;
  cardNum: number;
  expandedTime: string; // 展开持续时间(ms)
  sourceType: string;
}

export interface DragSubCardToDesktopEvent {
  formStackID: string;
  area: number[];
  page: number;
  column: number;
  row: number;
  dragCardPackageName: string;
  endPage: number;
  endColumn: number;
  endRow: number;
  cardNum: number;
  dragSourceType: string;
}

export interface AdjustSubCardsOrderEvent {
  formStackID: string;
  area: number[];
  dragCardPackageName: string;
  startIndex: number;
  endIndex: number;
  cardNum: number;
  sourceType?: string;
}

export interface ClickToPinningEvent {
  formStackID: string;
  area: number[];
  topCardPackageName: string;
  sourceType: string;
}

export interface RemoveSubCardEvent {
  formStackID: string;
  area: number[];
  deleteState: number;
  cardPackageName: string; // 删除的子卡片全包名
  num: number; // 剩余子卡片数量
  sourceType: string;
  // 删除的子卡片信息类型，0-普通卡片 1-互动卡片-场景动效 2-互动卡片-趣味交互
  formType: number;
}

/**
 * 卡片删除的方式
 * 0-左滑，不删除（swipe left but not delete）
 * 1-左滑，点击垃圾桶删除(swipe left and click to delete)
 * 2-左长滑删除(long swipe left and delete)
 */
export enum RemoveSubCardState {
  LEFT_SLIDE_NOT_DELETE,
  CLICK_DELETE,
  LEFT_SLIDE_DELETE,
}

export interface PeriodicStatisticsEvent {
  totalNum: number; // 桌面堆叠卡片的总数量
  formStackID: string;
  area: number[];
  page: number;
  column: number;
  row: number;
  totalSubCardsNum: number;
  subCardPackageName: string;
  //卡片类型，0-普通卡片 1-互动卡片-场景动效 2-互动卡片-趣味交互
  formType: number;
  formName: string;
  serialNum: string;
  presetsNum: number;
  upgradeNum: number;
  sourceType: string;
}

class DefaultReportParams {
  public PNAMEID: string = ReportParams.PACKAGE_NAME;
  public PVERSIONID: string = ReportParams.PROCESS_NAME;
}

class CreationReportParams extends DefaultReportParams {
  public DRAG_INFO: string = '';
  public OVER_INFO: string = '';
  public CARD_ID: string = '';
  public CARD_SIZE: string = '';
  public SCREEN_ID: number = -1;
  public CELL_X: number = -1;
  public CELL_Y: number = -1;
  public DRAG_SOURCE_TYPE: string = '';
  public OVER_SOURCE_TYPE: string = '';
}

class AddCardReportParams extends DefaultReportParams {
  public DRAG_INFO: string = '';
  public NUM: number = -1;
  public CARD_ID: string = '';
  public CARD_SIZE: string = '';
  public SCREEN_ID: number = -1;
  public CELL_X: number = -1;
  public CELL_Y: number = -1;
  public DRAG_SOURCE_TYPE: string = '';
}

class SwitchCardsReportParams extends DefaultReportParams {
  public CARD_ID: string = '';
  public CARD_SIZE: string = '';
  public SCREEN_ID: number = -1;
  public CELL_X: number = -1;
  public CELL_Y: number = -1;
  public TOP_INFO: string = '';
  public SLIDE_TYPE: number = 0;
}

class ShortcutMenuClickReportParams extends DefaultReportParams {
  public TYPE: number = -1;
  public CARD_ID: string = '';
  public CARD_SIZE: string = '';
  public TOP_INFO: string = '';
  public SOURCE_TYPE: string = '';
  public FORMTYPE: number = -1;
}

class MoveReportParams extends DefaultReportParams {
  public CARD_ID: string = '';
  public CARD_SIZE: string = '';
  public START_SCREEN_ID: number = -1;
  public START_CELL_X: number = -1;
  public START_CELL_Y: number = -1;
  public END_SCREEN_ID: number = -1;
  public END_CELL_X: number = -1;
  public END_CELL_Y: number = -1;
  public SOURCE_TYPE: string = '';
}

class ClickReportParams extends DefaultReportParams {
  public CARD_ID: string = '';
  public CARD_SIZE: string = '';
  public SUB_INFO: string = '';
  public SOURCE_TYPE: string = '';
  public SCREEN_TYPE: number = -1;
}

class ExpandReportParams extends DefaultReportParams {
  public CARD_ID: string = '';
  public CARD_SIZE: string = '';
  public SCREEN_ID: number = -1;
  public CELL_X: number = -1;
  public CELL_Y: number = -1;
  public CARD_NUM: number = -1;
}

class CollapseReportParams extends DefaultReportParams {
  public CARD_ID: string = '';
  public CARD_SIZE: string = '';
  public SCREEN_ID: number = -1;
  public CELL_X: number = -1;
  public CELL_Y: number = -1;
  public CARD_NUM: number = -1;
  public EXPANDED_TIME: string = '';
  public SOURCE_TYPE: string = '';
}

class DragSubCardToDesktopReportParams extends DefaultReportParams {
  public CARD_ID: string = '';
  public CARD_SIZE: string = '';
  public SCREEN_ID: number = -1;
  public CELL_X: number = -1;
  public CELL_Y: number = -1;
  public DRAG_INFO: string = '';
  public END_SCREEN_ID: number = -1;
  public END_CELL_X: number = -1;
  public END_CELL_Y: number = -1;
  public CARD_NUM: number = -1;
  public DRAG_SOURCE_TYPE: string = '';
}

class AdjustSubCardsOrderReportParams extends DefaultReportParams {
  public CARD_ID: string = '';
  public CARD_SIZE: string = '';
  public DRAG_INFO: string = '';
  public START_POSITION: number = -1;
  public END_POSITION: number = -1;
  public CARD_NUM: number = -1;
  public SOURCE_TYPE: string = '';
}

class ClickToPinningReportParams extends DefaultReportParams {
  public CARD_ID: string = '';
  public CARD_SIZE: string = '';
  public TOP_INFO: string = '';
  public SOURCE_TYPE: string = '';
}

class RemoveSubCardReportParams extends DefaultReportParams {
  public CARD_ID: string = '';
  public CARD_SIZE: string = '';
  public DELETE_STATE: number = -1;
  public INFO: string = '';
  public NUM: number = -1;
  public SOURCE_TYPE: string = '';
  public FORMTYPE: number = -1;
}

class PeriodicStatisticsReportParams extends DefaultReportParams {
  public NUMBER: number = -1; // 桌面堆叠卡片的总数量
  public CARD_ID: string = ''; // 堆叠卡片的ID
  public CARD_SIZE: string = ''; // 堆叠卡片的大小:2*1，2*2，4*2，4*4
  public SCREEN_ID: number = -1; // 堆叠卡片在桌面第几屏
  public CELL_X: number = -1;
  public CELL_Y: number = -1;
  public NUM: number = -1; // 堆叠卡片内卡片数量
  public INFO: string = ''; // 堆叠卡片内单张子卡片的包名
  public FORMTYPE: number = -1; // 堆叠卡片内单张子卡片的卡片类型
  public FORM_NAME: string = '';
  public SERIALNUM: string = ''; // 上报批次标识
  public PRESETS_NUM: number = -1;
  public UPGRADE_NUM: number = -1;
  public SOURCE_TYPE: string = '';
}

/**
 * Form Stack UE Util.
 */
export class FormStackHiSysEventUtil {
  private static readonly CREATE_FORM_STACK: string = 'CREATE_FORM_STACK';

  private static readonly ADD_CARD_TO_FORM_STACK: string = 'ADD_CARD_TO_FORM_STACK';

  private static readonly SLIDE_TO_SWITCH_CARDS: string = 'SLIDE_TO_SWITCH_CARDS';

  private static readonly CLICK_FORM_STACK_SHORTCUT_MENU: string = 'CLICK_FORM_STACK_SHORTCUT_MENU';

  // 拖拽移动堆叠卡片
  private static readonly MOVE_FORM_STACK: string = 'MOVE_FORM_STACK';

  private static readonly CLICK_FORM_STACK: string = 'CLICK_FORM_STACK';

  // 长下滑展开堆叠卡片
  private static readonly EXPAND_FORM_STACK: string = 'EXPAND_FORM_STACK';

  private static readonly COLLAPSE_FORM_STACK: string = 'COLLAPSE_FORM_STACK';

  private static readonly DRAG_SUBCARD_TO_DESKTOP: string = 'DRAG_SUBCARD_TO_DESKTOP';

  private static readonly ADJUST_SUBCARDS_ORDER: string = 'ADJUST_SUBCARDS_ORDER';

  private static readonly CLICK_TO_PIN_TO_THE_TOP: string = 'CLICK_TO_PIN_TO_THE_TOP';

  private static readonly REMOVE_CARD_OF_FORM_STACK: string = 'REMOVE_CARD_OF_FORM_STACK';

  private static readonly FORM_STACK_PERIODIC_REPORT: string = 'FORM_STACK_PERIODIC_REPORT';

  private static readonly OUTER_FORM_STACK_PERIODIC_REPORT: string = 'OUTER_FORM_STACK_PERIODIC_REPORT';

  /**
   * 创建新堆叠卡片
   */
  public static reportCreateFormStack(event: FormStackCreateEvent): void {
    let params: CreationReportParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      DRAG_INFO: event.dragItemPackageName,
      OVER_INFO: event.endItemPackageName,
      CARD_ID: event.formStackID,
      CARD_SIZE: `${event.area[0]}*${event.area[1]}`,
      SCREEN_ID: event.screenPage,
      CELL_X: event.column,
      CELL_Y: event.row,
      DRAG_SOURCE_TYPE: event.dragSourceType,
      OVER_SOURCE_TYPE: event.overSourceType,
    };
    reporter.reportBehavior(FormStackHiSysEventUtil.CREATE_FORM_STACK, params);
  }

  /**
   * 添加卡片到堆叠卡片
   */
  public static reportAddCard(event: FormStackAddCardEvent): void {
    let params: AddCardReportParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      DRAG_INFO: event.dragItemPackageName,
      NUM: event.totalNum,
      CARD_ID: event.formStackID,
      CARD_SIZE: `${event.area[0]}*${event.area[1]}`,
      SCREEN_ID: event.screenPage,
      CELL_X: event.column,
      CELL_Y: event.row,
      DRAG_SOURCE_TYPE: event.dragSourceType,
    };
    reporter.reportBehavior(FormStackHiSysEventUtil.ADD_CARD_TO_FORM_STACK, params);
  }

  /**
   * 滑动切换子卡片
   */
  public static reportSwitchCards(event: SwitchCardsEvent): void {
    let params: SwitchCardsReportParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      CARD_ID: event.formStackID,
      CARD_SIZE: `${event.area[0]}*${event.area[1]}`,
      SCREEN_ID: event.screenPage,
      CELL_X: event.column,
      CELL_Y: event.row,
      TOP_INFO: event.topCardPackageName,
      SLIDE_TYPE: event.slideType,
    };
    reporter.reportBehavior(FormStackHiSysEventUtil.SLIDE_TO_SWITCH_CARDS, params);
  }


  /**
   * 快捷菜单点击事件
   */
  public static reportClickShortcutMenu(event: ShortcutMenuClickEvent): void {
    let params: ShortcutMenuClickReportParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      TYPE: event.type,
      CARD_ID: event.formStackID,
      CARD_SIZE: `${event.area[0]}*${event.area[1]}`,
      TOP_INFO: event.topCardPackageName,
      SOURCE_TYPE: event.sourceType ?? '',
      FORMTYPE: event.formType ?? -1,
    };
    reporter.reportBehavior(FormStackHiSysEventUtil.CLICK_FORM_STACK_SHORTCUT_MENU, params);
  }

  /**
   * 移动堆叠卡片
   */
  public static reportMoveEvent(event: FormStackMoveEvent): void {
    let params: MoveReportParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      CARD_ID: event.formStackID,
      CARD_SIZE: `${event.area[0]}*${event.area[1]}`,
      START_SCREEN_ID: event.startPage,
      START_CELL_X: event.startColumn,
      START_CELL_Y: event.startRow,
      END_SCREEN_ID: event.endPage,
      END_CELL_X: event.endColumn,
      END_CELL_Y: event.endRow,
      SOURCE_TYPE: event.sourceType,
    };
    reporter.reportBehavior(FormStackHiSysEventUtil.MOVE_FORM_STACK, params);
  }

  /**
   * 点击堆叠卡片
   */
  public static reportClickEvent(event: FormStackClickEvent): void {
    let params: ClickReportParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      CARD_ID: event.formStackID,
      CARD_SIZE: `${event.area[0]}*${event.area[1]}`,
      SUB_INFO: event.topCardPackageName,
      SOURCE_TYPE: event.sourceType ?? '',
      SCREEN_TYPE: HiSysEventUtil.screenType,
    };
    reporter.reportBehavior(FormStackHiSysEventUtil.CLICK_FORM_STACK, params);
  }

  /**
   * 长下滑展开堆叠卡片
   */
  public static reportLongSlideDownExpand(event: FormStackExpandEventParam): void {
    let params: ExpandReportParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      CARD_ID: event.formStackID,
      CARD_SIZE: `${event.area[0]}*${event.area[1]}`,
      SCREEN_ID: event.page,
      CELL_X: event.column,
      CELL_Y: event.row,
      CARD_NUM: event.cardNum,
    };
    reporter.reportBehavior(FormStackHiSysEventUtil.EXPAND_FORM_STACK, params);
  }

  /**
   * 折叠/收起堆叠卡片
   */
  public static reportCollapse(event: FormStackCollapseEvent): void {
    let params: CollapseReportParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      CARD_ID: event.formStackID,
      CARD_SIZE: `${event.area[0]}*${event.area[1]}`,
      SCREEN_ID: event.page,
      CELL_X: event.column,
      CELL_Y: event.row,
      CARD_NUM: event.cardNum,
      EXPANDED_TIME: event.expandedTime,
      SOURCE_TYPE: event.sourceType,
    };
    reporter.reportBehavior(FormStackHiSysEventUtil.COLLAPSE_FORM_STACK, params);
  }

  /**
   * 拖动子卡片到桌面
   */
  public static reportDragSubCardToDesktop(event: DragSubCardToDesktopEvent): void {
    let params: DragSubCardToDesktopReportParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      CARD_ID: event.formStackID,
      CARD_SIZE: `${event.area[0]}*${event.area[1]}`,
      SCREEN_ID: event.page,
      CELL_X: event.column,
      CELL_Y: event.row,
      DRAG_INFO: event.dragCardPackageName,
      END_SCREEN_ID: event.endPage,
      END_CELL_X: event.endColumn,
      END_CELL_Y: event.endRow,
      CARD_NUM: event.cardNum,
      DRAG_SOURCE_TYPE: event.dragSourceType,
    };
    reporter.reportBehavior(FormStackHiSysEventUtil.DRAG_SUBCARD_TO_DESKTOP, params);
  }

  /**
   * 调整子卡片顺序
   */
  public static reportAdjustSubCardsOrder(event: AdjustSubCardsOrderEvent): void {
    let params: AdjustSubCardsOrderReportParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      CARD_ID: event.formStackID,
      CARD_SIZE: `${event.area[0]}*${event.area[1]}`,
      DRAG_INFO: event.dragCardPackageName,
      START_POSITION: event.startIndex,
      END_POSITION: event.endIndex,
      CARD_NUM: event.cardNum,
      SOURCE_TYPE: event.sourceType ?? '',
    };
    reporter.reportBehavior(FormStackHiSysEventUtil.ADJUST_SUBCARDS_ORDER, params);
  }

  /**
   * 点击置顶子卡片
   */
  public static reportClickToPinning(event: ClickToPinningEvent): void {
    let params: ClickToPinningReportParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      CARD_ID: event.formStackID,
      CARD_SIZE: `${event.area[0]}*${event.area[1]}`,
      TOP_INFO: event.topCardPackageName,
      SOURCE_TYPE: event.sourceType,
    };
    reporter.reportBehavior(FormStackHiSysEventUtil.CLICK_TO_PIN_TO_THE_TOP, params);
  }

  /**
   * 左滑或点击垃圾桶删除子卡片
   */
  public static reportRemoveSubCard(event: RemoveSubCardEvent): void {
    let params: RemoveSubCardReportParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      CARD_ID: event.formStackID,
      CARD_SIZE: `${event.area[0]}*${event.area[1]}`,
      DELETE_STATE: event.deleteState,
      INFO: event.cardPackageName,
      NUM: event.num,
      SOURCE_TYPE: event.sourceType,
      FORMTYPE: event.formType,
    };
    reporter.reportBehavior(FormStackHiSysEventUtil.REMOVE_CARD_OF_FORM_STACK, params);
  }

  /**
   * 堆叠卡片状态点
   */
  public static reportStatisticsData(events: PeriodicStatisticsEvent[], isOuter: boolean): void {
    if (events.length <= 0) {
      return;
    }
    let params: PeriodicStatisticsReportParams[] = events.map((event) => {
      let param: PeriodicStatisticsReportParams = {
        PNAMEID: ReportParams.PACKAGE_NAME,
        PVERSIONID: ReportParams.PROCESS_NAME,
        NUMBER: event.totalNum,
        CARD_ID: event.formStackID,
        CARD_SIZE: `${event.area[0]}*${event.area[1]}`,
        SCREEN_ID: event.page,
        CELL_X: event.column,
        CELL_Y: event.row,
        NUM: event.totalSubCardsNum,
        INFO: event.subCardPackageName,
        FORMTYPE: event.formType,
        FORM_NAME: event.formName,
        SERIALNUM: event.serialNum,
        PRESETS_NUM: event.presetsNum,
        UPGRADE_NUM: event.upgradeNum,
        SOURCE_TYPE: event.sourceType,
      };
      return param;
    });
    if (isOuter) {
      outerReporter.batchReportStatistic(FormStackHiSysEventUtil.OUTER_FORM_STACK_PERIODIC_REPORT, params);
    } else {
      reporter.batchReportStatistic(FormStackHiSysEventUtil.FORM_STACK_PERIODIC_REPORT, params);
    }
  }
}

