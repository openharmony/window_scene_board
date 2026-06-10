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

import curves from '@ohos.curves';
import { CheckEmptyUtils, DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import lazy { SCBScreenProperty } from '@ohos/windowscene/src/main/ets/screen/session/SCBScreenSession';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { ToggleEditType, ToggleEditViewData } from './ToggleEditViewData';
import { SysApiWrapper } from '../common/SysApiWrapper';
import Constants, {
  TOGGLE_LIST_OF_2_2,
  TOGGLE_SPACE_COMPACT,
  TOGGLE_SPACE_DIFF
} from '../common/Constants';
import { DragHelper, MoveDirection } from './DragHelper';
import { AccessibilityUtil } from '@ohos/screenlockcommon/src/main/ets/utils/AccessibilityUtil';
import { AccessibilityUtilExt } from '@ohos/controlcentercommon/src/main/ets/accessibility/AccessibilityUtilExt';
import { ScrollBlurController } from '@ohos/controlcentercommon/src/main/ets/scrollBlur/ScrollBlurController';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { ControlCenterHiSysEventUtil } from '@ohos/controlcentercommon/src/main/ets/hiSysEvent/ControlCenterHiSysEventUtil';
import { RTLUtil } from '@ohos/componenthelper';
import { FASlotName } from '@ohos/commonconstants';
import { ScreenSessionAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/ScreenSessionAdapter';

const TAG = 'TopToggleEditViewModel';
const log = LogHelper.getLogHelper(LogDomain.CC, TAG);
const TOGGLE_COLUMNS: number = 2;
const TOGGLE_HEIGHT: number = 64;
const TOGGLE_WIDTH: number = 144;
const ADD_BUTTON_HEIGHT: number = 48;
const TOGGLE_ROWS_GAP: number =  16;
const TOGGLE_COLUMN_GAP: number = 16;
const UPPER_LIMIT: string = '1';
const EXTRA_HEIGHT_IN_COMPACT_LAYOUT: number = 0;
const UNUSED_INDEX: number = -1;
const PREVIEW_PAGE_MIN_HEIGHT: number = 535;

export class TopToggleEditViewModel {
  private screenHeight: number = 836;
  public scroller: Scroller = new Scroller();
  public previewToggles: string[] = [];
  public libraryToggles: string[] = [];
  private previewGridPlaceholder: number[][] = [];
  private addToggleTimeOut: number | null = null;
  public presetToggleOrder: Map<string, number> = new Map();
  public showToast?: (msg: ResourceStr) => void;
  private isSupportMoveSteps = (toggleIndex: number, direction: MoveDirection): boolean => false;
  public scrollBlurController?: ScrollBlurController;
  private viewData: ToggleEditViewData;
  private showDoubleColumn: boolean;
  private dragHelper: DragHelper;

  constructor(viewData: ToggleEditViewData, showDoubleColumn: boolean) {
    this.viewData = viewData;
    this.showDoubleColumn = showDoubleColumn;
    this.dragHelper = new DragHelper(this.viewData, TOGGLE_WIDTH + TOGGLE_COLUMN_GAP, TOGGLE_HEIGHT + TOGGLE_ROWS_GAP,
      TOGGLE_COLUMNS);
    this.dragHelper.updateMoveItemFunc(this.moveItemFunc);
    this.dragHelper.updateMoveTargetIndexFun(this.getMoveTargetIndex);
    this.dragHelper.updateSupportMoveFun(this.isSupportMove, this.isSupportMoveSteps);
    let screenProperty: SCBScreenProperty = ScreenSessionAdapter.getSCBScreenProperty();
    this.screenHeight = px2vp(screenProperty.height);
  }

  private getMoveTargetIndex = (toggleIndex: number, direction: MoveDirection): number => {
    let holderIndex: number[] = this.getGridPlaceholderIndex(toggleIndex);
    log.showInfo(`getMoveTargetIndex toggleIndex:${toggleIndex}, holderIndex:${holderIndex}, direction:${direction}`);
    let targetIndex: number = UNUSED_INDEX;
    switch (direction) {
      case MoveDirection.UP:
        targetIndex = this.getTargetIndex(holderIndex[0] - 1, holderIndex[1]);
        break;
      case MoveDirection.DOWN:
        let isCombinedToggle: boolean = this.isCombinedToggle(this.previewToggles[toggleIndex]);
        targetIndex = this.getTargetIndex((isCombinedToggle ? holderIndex[0] + 2 : holderIndex[0] + 1), holderIndex[1]);
        break;
      case MoveDirection.LEFT:
        targetIndex = this.getTargetIndex(holderIndex[0], (RTLUtil.isRTL() ? holderIndex[1] + 1 : holderIndex[1] - 1));
        break;
      case MoveDirection.RIGHT:
        targetIndex = this.getTargetIndex(holderIndex[0], (RTLUtil.isRTL() ? holderIndex[1] - 1 : holderIndex[1] + 1));
        break;
      case MoveDirection.UP_RIGHT:
        targetIndex =
          this.getTargetIndex(holderIndex[0] - 1, (RTLUtil.isRTL() ? holderIndex[1] - 1 : holderIndex[1] + 1));
        break;
      case MoveDirection.UP_LEFT:
        targetIndex =
          this.getTargetIndex(holderIndex[0] - 1, (RTLUtil.isRTL() ? holderIndex[1] + 1 : holderIndex[1] - 1));
        break;
      case MoveDirection.DOWN_RIGHT:
        targetIndex =
          this.getTargetIndex(holderIndex[0] + 1, (RTLUtil.isRTL() ? holderIndex[1] - 1 : holderIndex[1] + 1));
        break;
      case MoveDirection.DOWN_LEFT:
        targetIndex =
          this.getTargetIndex(holderIndex[0] + 1, (RTLUtil.isRTL() ? holderIndex[1] + 1 : holderIndex[1] - 1));
        break;
      default:
        break;
    }
    log.showInfo(`getMoveTargetIndex targetIndex:${targetIndex} `);
    return targetIndex;
  }

  /**
   * 寻找index坐标的开关在grid布局中的位置
   *
   * @param toggleIndex
   * @returns
   */
  private getGridPlaceholderIndex(toggleIndex: number): number[] {
    for (let row = 0; row < this.previewGridPlaceholder.length; row++) {
      for (let col = 0; col < this.previewGridPlaceholder[row].length; col++) {
        if (this.previewGridPlaceholder[row][col] === toggleIndex) {
          return [row, col];
        }
      }
    }
    return [0, 0];
  }

  /**
   * 获取开关布局中对应坐标位置的开关序号
   * @param targetRow 行号
   * @param targetCol 列号
   * @returns 开关序号
   */
  private getTargetIndex(targetRow: number, targetCol: number): number {
    log.showInfo(`getTargetIndex: (${targetRow},${targetCol})`);
    if (targetRow >= this.previewGridPlaceholder.length || targetRow < 0) {
      return UNUSED_INDEX;
    }
    if (targetCol >= this.previewGridPlaceholder[targetRow].length || targetCol < 0) {
      return UNUSED_INDEX;
    }
    return this.previewGridPlaceholder[targetRow][targetCol];
  }


  /**
   * 移动方向是否是斜向移动
   * @param direction 移动方向
   * @returns
   */
  private isDiagonalMove(direction: MoveDirection): boolean {
    return [MoveDirection.UP_RIGHT, MoveDirection.UP_LEFT, MoveDirection.DOWN_RIGHT,
      MoveDirection.DOWN_LEFT].includes(direction);
  }

  /**
   * 判断toggleIndex对应的开关是否支持往目标方向移动
   */
  private isSupportMove = (toggleIndex: number, direction: MoveDirection): boolean => {
    let holderIndex: number[] = this.getGridPlaceholderIndex(toggleIndex);
    let targetIndex: number = this.getMoveTargetIndex(toggleIndex, direction);
    // 如果是斜向移动
    if (this.isDiagonalMove(direction)) {
      // 2*2尺寸的开关不允许被斜向挤位
      if (targetIndex === UNUSED_INDEX || this.isCombinedToggle(this.previewToggles[targetIndex])) {
        log.showInfo(`isSupportMove direction: ${direction}  false`)
        return false;
      // 如果拖拽的是2*2尺寸的开关，不允许向右下挤位
      } else if (this.isCombinedToggle(this.previewToggles[toggleIndex]) && (
        direction === MoveDirection.DOWN_RIGHT && !RTLUtil.isRTL() ||
        direction === MoveDirection.DOWN_LEFT && RTLUtil.isRTL() ||
        !this.isInsertCombinedToggle(targetIndex))) {
        return false;
      }
      log.showInfo(`isSupportMove direction: ${direction}  true`)
      return true;
    }
    // 如果是竖向挤位，1*2卡片无法挤位2*2组合开关
    if (direction === MoveDirection.UP || direction === MoveDirection.DOWN) {
      if (this.isCombinedToggle(this.previewToggles[targetIndex])) {
        log.showInfo(`isSupportMove direction: ${direction}, isCombinedToggle`);
        return false;
      }
      log.showInfo(`isSupportMove direction: ${direction}, targetIndex: ${targetIndex}`)
      return targetIndex !== UNUSED_INDEX;
    }
    // 如果1*2开关横向挤位的目标是2*2组合开关，需要额外增加判断，1*2开关下方必须有空位,且与2*2开关上半部分在同一行
    if (targetIndex !== UNUSED_INDEX && this.isCombinedToggle(this.previewToggles[targetIndex]) &&
      !this.isCombinedToggle(this.previewToggles[toggleIndex])) {
      const canMove: boolean = Math.abs(targetIndex - toggleIndex) === 1 &&
        this.previewGridPlaceholder.length > holderIndex[0] + 1 &&
        this.previewGridPlaceholder[holderIndex[0] + 1][holderIndex[1]] === UNUSED_INDEX;
      if (!canMove) {
        targetIndex = UNUSED_INDEX;
      }
    }
    log.showInfo(`isSupportMove direction${direction}  ${targetIndex !== UNUSED_INDEX}`)
    return targetIndex !== UNUSED_INDEX;
  }

  /**
   * 判断斜向移动2*2挤位后能否被容纳
   */
  private isInsertCombinedToggle(targetIndex: number): boolean {
    let holderIndex: number[] = this.getGridPlaceholderIndex(targetIndex);
    log.showInfo(`holderIndex row: ${holderIndex[0]}, col: ${holderIndex[1]}`);
    if (holderIndex && holderIndex?.length === TOGGLE_COLUMNS) {
      return holderIndex[0] + 1 < Constants.TOP_TOGGLE_ROWS_MAX;
    }
    return false;
  }

  // 切换开关位置，将fromIndex与toIndex互换位置
  private moveItemFunc = (fromIndex: number, toIndex: number) => {
    if (fromIndex >= this.previewToggles.length || toIndex >= this.previewToggles.length) {
      return;
    }
    if (fromIndex < 0 || toIndex < 0) {
      return;
    }
    let beforeRows: number = this.getToggleRows(this.previewToggles);
    if (!this.isVerticalDragCombinedToggle(fromIndex, toIndex)) {
      let tmp = this.previewToggles[fromIndex];
      this.previewToggles[fromIndex] = this.previewToggles[toIndex]
      this.previewToggles[toIndex] = tmp;
    }
    // 如果位置切换完之后2*2开关到最后一个位置，需要进行调换
    if (this.getToggleRows(this.previewToggles) > Constants.TOP_TOGGLE_ROWS_MAX) {
      let toggle: string | undefined = this.previewToggles.pop();
      if (toggle !== undefined) {
        this.previewToggles.splice(this.previewToggles.length - 1, 0, toggle);
      }
    }
    let afterRows: number = this.getToggleRows(this.previewToggles);
    // 切换完之后开关行数有变化，需要刷新预览页框高度
    if (beforeRows !== afterRows) {
      SysApiWrapper.animateTo({
        duration: 250,
      }, () => {
        this.updatePreviewHeight();
      })
    }
    // 播报落点
    let togglePosition: number[] = this.getGridPlaceholderIndex(toIndex);
    AccessibilityUtil.sendAccessibility(ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_edit_coordinates'),
      togglePosition[0] + 1, togglePosition[1] + 1));
  }

  /**
   * 判断是否组合开关竖向拖动
   *
   * @param fromIndex 源组件
   * @param toIndex 目标组件
   * @returns
   */
  private isVerticalDragCombinedToggle(fromIndex: number, toIndex: number): boolean {
    const toggleNumber: number = this.previewToggles.length;
    let formToggle: string = this.previewToggles[fromIndex];
    let toToggle: string = this.previewToggles[toIndex];
    if (this.isCombinedToggle(formToggle) && Math.abs(fromIndex - toIndex) > 1) {
      if (fromIndex > toIndex) {
        // 向上拖动
        this.previewToggles.splice(fromIndex, 1);
        this.previewToggles[toIndex] = formToggle;
        if (fromIndex + 2 < toggleNumber) {
          this.previewToggles.splice(fromIndex + 1, 0, toToggle);
        } else {
          this.previewToggles.push(toToggle);
        }
      } else {
        // 向下拖动
        this.previewToggles.splice(toIndex, 1);
        this.previewToggles[fromIndex] = toToggle;
        this.previewToggles.splice(fromIndex + 2, 0, formToggle);
      }
      return true;
    }
    return false;
  }

  public onViewAppear(): void {
    this.initPresetTogglesOrder();
    this.updatePreviewHeight();
    this.dragHelper.previewToggles = this.previewToggles;
  }

  public onAddButtonClicked(): void {
    log.showInfo('onAddButtonClicked');
    this.showLibraryPanel();
    if (this.showDoubleColumn) {
      focusControl.requestFocus('Ctrl.ToggleEditView_Close_Candidate_Library_Btn');
    } else {
      focusControl.requestFocus('Ctrl.ToggleEditView_Drag_Bar' + ToggleEditType.TOP_TOGGLE);
    }
  }

  public onToggleClicked(item: string, inPreview: boolean, idx?: number): void {
    if (inPreview) {
      this.removeToggle(item, idx);
    } else {
      this.addToggle(item);
    }
  }

  private initPresetTogglesOrder() {
    let presetAllToggles = ResUtils.getInnerString($r('app.string.top_toggle_data_all')) ?? '';
    presetAllToggles.split(',').forEach((slot, idx) => {
      this.presetToggleOrder.set(slot, idx);
    });
    this.libraryToggles.sort((slotA, slotB) => {
      if (this.presetToggleOrder.has(slotA) && this.presetToggleOrder.has(slotB)) {
        return this.presetToggleOrder[slotA] - this.presetToggleOrder[slotB];
      }
      return 0;
    });
  }

  private addToggle(item: string) {
    // 防止快速添加开关导致开关数量异常
    if (this.addToggleTimeOut !== null) {
      log.showInfo(`topToggle is adding`);
      return;
    }
    TraceUtil.startTrace(DomainName.CC, 'addTopToggle');
    if (!this.canAddToggle(item)) {
      this.showToast?.(ResUtils.getInnerString($r('app.string.control_center_edit_panel_tips_max_limit')));
      // 控制中心编辑头部开关数量限制toast提示打点
      ControlCenterHiSysEventUtil.reportCCNumberSwitchToast({
        UPPERLOWERTHRESHOLDSSWITCHVALUE: UPPER_LIMIT,
        TOASTNUMBERSWITCHVALUE: Constants.QUICK_TOGGLE_MAX.toString(),
        TIMESTAMP: DropDownPanelManager.getLastDropdownTime().toString(),
      })
      TraceUtil.endTrace(DomainName.CC, 'addTopToggle');
      AccessibilityUtil.sendAccessibility(AccessibilityUtilExt.getEditToggleReportText(this.previewToggles.length + 1,
        Constants.QUICK_TOGGLE_MAX, Constants.QUICK_TOGGLE_MIN, TOGGLE_COLUMNS, true));
      return;
    }
    ControlCenterHiSysEventUtil.reportCCEditAddQuickSwitch({
      TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      SWITCHNUMBER: this.previewToggles.length + 1,
      SWITCHNAME: item,
    })
    SysApiWrapper.animateTo({
      duration: 250,
      onFinish: () => {
        TraceUtil.endTrace(DomainName.CC, 'addTopToggle');
        this.sendAddToggleAccessibility(item);
        AccessibilityUtil.requestFocusAccessibility('Ctrl.ToggleEditView_Add_Btn' + ToggleEditType.TOP_TOGGLE);
      }
    }, () => {
      if (!this.removeItem(item, this.libraryToggles)) {
        log.error(`remove item from libraryToggles failed: ${item}`);
        return;
      }
      let currentRows: number = this.getToggleRows(this.previewToggles);
      let targetRows: number = this.getToggleRows(this.previewToggles.concat(item));
      if (currentRows !== targetRows) {
        if (currentRows === 2 && currentRows === targetRows - 2 && this.isCombinedToggle(item)) {
          // 需要新增行，提前更新
          this.updatePreviewHeight(TOGGLE_HEIGHT + TOGGLE_ROWS_GAP);
          this.addToggleTimeOut = SysApiWrapper.setTimeout(() => {
            if (this.previewToggles.length > 1 && this.isCombinedToggle(item)) {
              this.previewToggles.splice(1, 0, item);
            } else {
              this.previewToggles.splice(this.previewToggles.length - 1, 0, item);
            }
            this.addToggleTimeOut = null;
          }, 150);
        } else {
          // 需要新增行，提前更新
          this.updatePreviewHeight((TOGGLE_HEIGHT + TOGGLE_ROWS_GAP) * (targetRows - currentRows));
          this.addToggleTimeOut = SysApiWrapper.setTimeout(() => {
            if (this.previewToggles.length > 1 && this.isCombinedToggle(item)) {
              this.previewToggles.splice(1, 0, item);
            } else {
              this.previewToggles.push(item);
            }
            this.addToggleTimeOut = null;
          }, 150);
        }
        this.updateScrollOffset();
      } else {
        this.addToggleTimeOut = SysApiWrapper.setTimeout(() => {
          this.previewToggles.push(item);
          this.addToggleTimeOut = null;
        }, 50);
      }
    });
  }

  /**
   * 添加开关的无障碍播报
   * @param item 开关名称
   */
  public sendAddToggleAccessibility(item: string): void {
    // 播放无障碍
    log.showInfo('sendAddToggleAccessibility item: ' + item)
    let toggleIndex: number = this.previewToggles.indexOf(item);
    if (toggleIndex === -1) {
      return;
    }
    let togglePosition: number[] = this.getGridPlaceholderIndex(toggleIndex);
    AccessibilityUtil.sendAccessibility(ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_edit_add_toggle_coordinates'),
      togglePosition[0] + 1, togglePosition[1] + 1));
  }

  /**
   * 预览页删除开关
   *
   * @param item
   * @param idx
   */
  private removeToggle(item: string, idx?: number) {
    ControlCenterHiSysEventUtil.reportCCEditRemoveQuickSwitch({
      TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      SWITCHNUMBER: this.previewToggles.length - 1,
      SWITCHNAME: item,
      SWITCHLOCATION: idx ? idx : 0,
    })
    log.showInfo('removeTopToggle item: ' + item)
    TraceUtil.startTrace(DomainName.CC, 'removeTopToggle');
    SysApiWrapper.animateTo({
      duration: 250,
      onFinish: () => {
        TraceUtil.endTrace(DomainName.CC, 'removeTopToggle');
        AccessibilityUtil.sendAccessibility(AccessibilityUtilExt.getEditToggleReportText(this.previewToggles.length,
          Constants.TOP_TOGGLE_ROWS_MAX, Constants.QUICK_TOGGLE_MIN, TOGGLE_COLUMNS, false));
        AccessibilityUtil.requestFocusAccessibility('Ctrl.ToggleEditView_Remove_Btn' + ToggleEditType.TOP_TOGGLE);
      }
    }, () => {
      let currentRows: number = this.getToggleRows(this.previewToggles);
      if (!this.removeItem(item, this.previewToggles)) {
        log.showError(`remove item from previewTopToggles failed: ${item}`);
        return;
      }
      let targetRows: number = this.getToggleRows(this.previewToggles);
      SysApiWrapper.setTimeout(() => {
        log.showInfo('insertToLibraryToggles and updatePreviewHeight');
        this.insertToLibraryToggles(item);
        if (currentRows === targetRows) {
          return;
        }
        SysApiWrapper.animateTo({
          duration: 200,
        }, () => {
          this.updatePreviewHeight();
        })
      }, 100);
    });
  }

  private insertToLibraryToggles(item: string) {
    let hasInserted: boolean = false;
    for (let i = 0; i < this.libraryToggles.length; ++i) {
      let currentToggle = this.libraryToggles[i];
      let itemIndex: number | undefined = this.presetToggleOrder.get(item);
      let currentToggleIndex: number | undefined = this.presetToggleOrder.get(currentToggle);
      if (currentToggleIndex !== undefined && itemIndex !== undefined && itemIndex < currentToggleIndex) {
        this.libraryToggles.splice(i, 0, item);
        hasInserted = true;
        break;
      }
    }
    if (!hasInserted) {
      this.libraryToggles.push(item);
    }
  }

  private removeItem<T>(item: T, data: T[]): boolean {
    log.showInfo(`remove item: ${item},from toggles: ${data}`);
    let idx = data.indexOf(item);
    if (idx < 0) {
      return false;
    }
    data.splice(idx, 1);
    return true;
  }

  private showLibraryPanel() {
    TraceUtil.startTrace(DomainName.CC, 'showLibraryPanel');
    ControlCenterHiSysEventUtil.reportCCEditExpandLibrary({
      TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      SWITCHNUMBER: this.libraryToggles.length,
      SWITCHLIST: this.libraryToggles.join(','),
    })
    SysApiWrapper.animateTo({
      duration: 450,
      curve: curves.springCurve(0, 1, 228, 28),
      onFinish: () => {
        TraceUtil.endTrace(DomainName.CC, 'showLibraryPanel');
        AccessibilityUtil.requestFocusAccessibility('Ctrl.ToggleEditView_Add_Btn' + ToggleEditType.TOP_TOGGLE);
      },
    }, () => {
      this.viewData.showTopToggleLibrary = true;
      this.viewData.topLibraryTrans = 0;
      this.updatePreviewHeight();
      this.updateScrollOffset();
    });
  }

  /**
   * 单列开关屏幕展示不下时进行列表滚动
   */
  private updateScrollOffset(): void {
    if (!this.showDoubleColumn) {
      const heightDiff: number = this.screenHeight - this.viewData.editTopPreviewPanelHeight;
      log.showInfo(`updateScrollOffset screenHeight:${this.screenHeight} , diff:${heightDiff}`);
      if (heightDiff < PREVIEW_PAGE_MIN_HEIGHT) {
        let offsetY: number =
          Math.ceil((PREVIEW_PAGE_MIN_HEIGHT - heightDiff) / (TOGGLE_HEIGHT + TOGGLE_ROWS_GAP)) *
            (TOGGLE_HEIGHT + TOGGLE_ROWS_GAP);
        this.scrollBlurController?.activeScrollerBlur();
        this.scroller.scrollTo({ xOffset: 0, yOffset: offsetY })
        return;
      }
    }
    this.scrollBlurController?.inactiveScrollerBlur();
    this.scroller.scrollTo({ xOffset: 0, yOffset: 0 })
  }

  /**
   * 根据开关列表计算开关grid布局高度
   *
   * @param toggles 开关列表
   * @returns grid布局高度
   */
  public getToggleGridHeight(toggles: string[]): number {
    if (toggles.length === 0) {
      return 0;
    }
    let rows: number = this.getToggleRows(toggles);
    let gridHeight = rows * TOGGLE_HEIGHT + (rows - 1) * TOGGLE_ROWS_GAP;
    log.showInfo(`getToggleGridHeight rows: ${rows} height: ${gridHeight}`);
    return gridHeight;
  }

  /**
   * 根据开关列表计算开关行数
   *
   * @param toggles 开关列表
   * @returns 开关行数
   */
  public getToggleRows(toggles: string[]): number {
    if (toggles.length === 0) {
      return 0;
    }
    let startIndex: number = 0;
    let endIndex: number = 0;
    let numberOf2x2: number = 0;
    let rowNumber: number = 0;
    while (endIndex < toggles.length) {
      if (TOGGLE_LIST_OF_2_2.includes(toggles[endIndex])) {
        numberOf2x2++;
      }
      // 如果startIndex到endIndex之间的开关可以凑成一行
      if (numberOf2x2 === 0 && endIndex - startIndex === TOGGLE_COLUMNS - 1) {
        rowNumber += 1;
        startIndex = endIndex + 1;
      } else if (numberOf2x2 > 0 && endIndex - startIndex === 2 * TOGGLE_COLUMNS - numberOf2x2 - 1) {
        rowNumber += 2;
        numberOf2x2 = 0;
        startIndex = endIndex + 1;
      } else if (endIndex === toggles.length - 1) {
        rowNumber += (numberOf2x2 > 0 ? 2 : 1);
        numberOf2x2 = 0;
      }
      endIndex++;
    }
    log.showInfo(`getToggleRows: ${toggles.toString()}   rows: ${rowNumber}`)
    return rowNumber;
  }

  /**
   * 是否能够继续添加卡片
   *
   * @param toggle
   * @returns
   */
  private canAddToggle(toggle: string): boolean {
    let newToggleList: string[] = this.previewToggles.concat(toggle);
    if (this.isCombinedToggle(toggle)) {
      newToggleList.reverse()
    }
    return this.getToggleRows(newToggleList) <= Constants.TOP_TOGGLE_ROWS_MAX;
  }

  /**
   * 根据当前开关列表更新预览框高度
   *
   * @param extraHeight 需要额外增加的高度
   */
  public updatePreviewHeight(extraHeight: number = 0): void {
    let rows = this.getToggleRows(this.previewToggles);
    let length = rows * TOGGLE_HEIGHT + (rows + 1) * TOGGLE_ROWS_GAP + extraHeight;
    if (!this.viewData.showTopToggleLibrary) {
      length += TOGGLE_ROWS_GAP + ADD_BUTTON_HEIGHT + EXTRA_HEIGHT_IN_COMPACT_LAYOUT;
    }
    log.showInfo(`updatePreviewHeight rows: ${rows}, height: ${length}`);
    this.viewData.editTopPreviewPanelHeight = length;
  }

  public onLongPressActionForDrag = (item: string) => {
    this.dragHelper.onLongPressActionForDrag(item, this.getEditToggleText);
  }
  public onLongPressActionEndForDrag = () => {
    this.dragHelper.onLongPressActionEndForDrag(this.getEditToggleText);
  };
  public onActionStartForDrag = (item: string) => {
    this.dragHelper.onActionStartForDrag(item);
  }
  public onActionUpdateForDrag = (event: GestureEvent) => {
    this.dragHelper.onActionUpdateForDrag(event);
  }
  public onActionEndForDrag = () => {
    if (AccessibilityUtil.isAccessibilityMode()) {
      let toggleIndex: number = this.previewToggles.indexOf(this.viewData.dragItem);
      if (toggleIndex === -1) {
        return;
      }
      let togglePosition: number[] = this.getGridPlaceholderIndex(toggleIndex);
      let toggleMoveItemText =
        ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_edit_coordinates'), togglePosition[0] + 1,
          togglePosition[1] + 1);
      AccessibilityUtil.sendAccessibility(
        this.getEditToggleText(this.viewData.dragItem) +
        ResUtils.getInnerString($r('app.string.cc_accessibility_str_edit_move_end')) + toggleMoveItemText);
    }
    this.dragHelper.onActionEndForDrag();
  }

  // 对于目前获焦的组件，主动消费掉对应的按键
  onKeyPreForbidAction(event: KeyEvent, direction: number): boolean {
    return direction === event.keyCode;
  }

  // 判断当前1x1按钮是否排在ListItem的第一个
  isLeftComponent(id: string) {
    if ((this.previewToggles.indexOf(id) % 4 === 0) || this.libraryToggles.indexOf(id) % 4 === 0) {
      return true;
    }
    return false;
  }

  /**
   * 是否是2*2尺寸的组合开关
   *
   * @param topToggle 开关名称
   * @returns
   */
  public isCombinedToggle(topToggle?: string): boolean {
    if (!topToggle) {
      return false;
    }
    return TOGGLE_LIST_OF_2_2.includes(topToggle);
  }

  /**
   * 对头部开关进行布局
   *
   * @param inPreview 是否预览页开关
   * @returns
   */
  public topGridLayoutOptions(inPreview: boolean): GridLayoutOptions {
    let topToggles = inPreview ? this.previewToggles : this.libraryToggles;
    let togglesRowNum = this.getToggleRows(topToggles);
    let placeholder: number[][] = this.createBooleanMatrix(togglesRowNum, TOGGLE_COLUMNS);
    // 预览页的开关布局发生变化时刷新占位标志表
    if (inPreview) {
      this.previewGridPlaceholder = placeholder;
    }

    return {
      regularSize: [1, 1],
      onGetRectByIndex: (index: number) => {
        const isCombinedToggle: boolean = this.isCombinedToggle(topToggles[index]);
        let result = this.occupyAvailableSpaces(index, isCombinedToggle, placeholder);
        log.showInfo(`topGridLayoutOptions index:${index}, isCombinedToggle: ${isCombinedToggle}, result: ${result.toString()}, placeholder: ${JSON.stringify(placeholder)} , previewGridPlaceholder:${JSON.stringify(this.previewGridPlaceholder)} `)
        if (isCombinedToggle) {
          return [result[0], result[1], 2, 2];
        }
        return [result[0], result[1], 1, 2];
      }
    }
  }

  private occupyAvailableSpaces(index: number, isCombinedToggle: boolean, placeholder: number[][]): number[] {
    const rowsNum: number = placeholder.length;
    let canOccupyNum: number = isCombinedToggle ? rowsNum - 1 : rowsNum;
    for (let row = 0; row < canOccupyNum; row++) {
      for (let col = 0; col < placeholder[row].length; col++) {
        if (placeholder[row][col] === UNUSED_INDEX) {
          placeholder[row][col] = index;
          if (isCombinedToggle && placeholder[row + 1][col] === UNUSED_INDEX) {
            placeholder[row + 1][col] = index;
          }
          return [row, col * 2];
        } else if (placeholder[row][col] === index) {
          return [row, col * 2];
        }
      }
    }
    return [0, 0];
  }

  private createBooleanMatrix(rows: number, cols: number): number[][] {
    let result: number[][] = [];
    for (let row = 0; row < rows; row++) {
      result.push(new Array(cols).fill(UNUSED_INDEX))
    }
    return result;
  }

  private getTopToggleName(slot: string): string {
    switch (slot) {
      case FASlotName.COMBINED_SLIDER:
        return ResUtils.getInnerString($r('app.string.combined_slider_title'));
      case FASlotName.BRIGHTNESS:
        return ResUtils.getInnerString($r('app.string.brightness_title'));
      default:
        return '';
    }
  }

  /**
   * 情景模式下，专注模式开关会替换为情景模式
   * @param slot开关名称
   * @returns
   */
  private checkScenarioMode(slot: string): string {
    if (slot === FASlotName.FOCUS_MODE) {
      const isIntelligentSceneEnable: boolean = AppStorage.get<boolean>('IntelligentSceneEnable') ?? false;
      if (isIntelligentSceneEnable) {
        slot = FASlotName.SCENARIO_MODE;
      }
    }
    return slot;
  }

  /**
   * 获取头部开关编辑角标按钮无障碍播报文案获取开关编辑角标按钮无障碍播报文案
   *
   * @param state 开关信息
   * @returns 播报文案
   */
  public getEditToggleActionText(slot: string): string {
    let toggleName: string = this.getTopToggleName(slot);
    if (!CheckEmptyUtils.checkStrIsEmpty(toggleName)) {
      return ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_edit_remove_toggle_new'), toggleName);
    }
    slot = this.checkScenarioMode(slot);
    return AccessibilityUtilExt.getEditToggleActionText(slot);
  }

  /**
   * 获取头部开关开关名称
   *
   * @param state 开关信息
   * @returns 播报文案
   */
  public getEditToggleText = (slot: string): string => {
    let toggleName: string = this.getTopToggleName(slot);
    if (!CheckEmptyUtils.checkStrIsEmpty(toggleName)) {
      return toggleName;
    }
    slot = this.checkScenarioMode(slot);
    return AccessibilityUtilExt.getEditToggleText(slot);
  }

  /**
   * 获取备选库头部开关无障碍播报文案
   *
   * @param state 开关信息
   * @returns 备选库开关播报文案
   */
  public getEditPreviewToggleText(slot: string): string {
    let toggleName: string = this.getTopToggleName(slot);
    if (!CheckEmptyUtils.checkStrIsEmpty(toggleName)) {
      return ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_edit_add_toggle'), toggleName);
    }
    slot = this.checkScenarioMode(slot);
    return AccessibilityUtilExt.getEditPreviewToggleText(slot);
  }
}