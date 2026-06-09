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
import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { ToggleEditType, ToggleEditViewData } from './ToggleEditViewData';
import { SysApiWrapper } from '../common/SysApiWrapper';
import Constants, { TOGGLE_SPACE_COMPACT, TOGGLE_SPACE_DIFF } from '../common/Constants';
import { DragHelper } from './DragHelper';
import { AccessibilityUtil } from '@ohos/screenlockcommon/src/main/ets/utils/AccessibilityUtil';
import { AccessibilityUtilExt } from '@ohos/controlcentercommon/src/main/ets/accessibility/AccessibilityUtilExt';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { ScrollBlurController } from '@ohos/controlcentercommon/src/main/ets/scrollBlur/ScrollBlurController';
import { ControlCenterHiSysEventUtil } from '@ohos/controlcentercommon/src/main/ets/hiSysEvent/ControlCenterHiSysEventUtil';
import {
  ControlCenterAccessibilityDataModel
} from '@ohos/controlcentercommon/src/main/ets/accessibility/AccessibilityDataModel';

const TAG = 'QuickToggleEditViewModel';
const log = LogHelper.getLogHelper(LogDomain.CC, TAG);
const TOGGLE_COLUMNS: number = 4;
const TOGGLE_WIDTH: number = 64;
const TOGGLE_HEIGHT: number = 84;
const ADD_BUTTON_HEIGHT: number = 48;
const TOGGLE_ROWS_GAP: number = 16;
const TOGGLE_COLUMN_GAP: number = 16;
const UPPER_LIMIT: string = '1';
const LOWER_LIMIT: string = '2';
const EXTRA_HEIGHT_IN_COMPACT_LAYOUT: number = 0;

export class QuickToggleEditViewModel {
  public scroller: Scroller = new Scroller();
  public previewToggles: string[] = [];
  public libraryToggles: string[] = [];
  public presetToggleOrder: Map<string, number> = new Map();
  public showToast?: (msg: ResourceStr) => void;
  public scrollBlurController?: ScrollBlurController;
  private viewData: ToggleEditViewData;
  private showDoubleColumn: boolean;
  private dragHelper: DragHelper;

  constructor(viewData: ToggleEditViewData, showDoubleColumn: boolean) {
    this.viewData = viewData;
    this.showDoubleColumn = showDoubleColumn;
    this.dragHelper = new DragHelper(this.viewData, TOGGLE_WIDTH + TOGGLE_COLUMN_GAP, TOGGLE_HEIGHT + TOGGLE_ROWS_GAP,
      TOGGLE_COLUMNS);
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
      focusControl.requestFocus('Ctrl.ToggleEditView_Drag_Bar' + ToggleEditType.QUICK_TOGGLE);
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
    let presetAllToggles = ResUtils.getInnerString($r('app.string.toggle_data_all')) ?? '';
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
    TraceUtil.startTrace(DomainName.CC, 'addToggle');
    if (this.previewToggles.length >= Constants.QUICK_TOGGLE_MAX) {
      this.showToast?.(ResUtils.getInnerString($r('app.string.control_center_edit_panel_tips_max_limit')));
      // 控制中心编辑快捷开关数量限制toast提示打点
      ControlCenterHiSysEventUtil.reportCCNumberSwitchToast({
        UPPERLOWERTHRESHOLDSSWITCHVALUE: UPPER_LIMIT,
        TOASTNUMBERSWITCHVALUE: Constants.QUICK_TOGGLE_MAX.toString(),
        TIMESTAMP: DropDownPanelManager.getLastDropdownTime().toString(),
      })
      TraceUtil.endTrace(DomainName.CC, 'addToggle');
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
        TraceUtil.endTrace(DomainName.CC, 'addToggle');
        // 播放无障碍
        AccessibilityUtil.sendAccessibility(AccessibilityUtilExt.getEditToggleReportText(this.previewToggles.length,
          Constants.QUICK_TOGGLE_MAX, Constants.QUICK_TOGGLE_MIN, TOGGLE_COLUMNS, true));
        AccessibilityUtil.requestFocusAccessibility('Ctrl.ToggleEditView_Add_Btn');
      }
    }, () => {
      if (!this.removeItem(item, this.libraryToggles)) {
        log.error(`remove item from libraryToggles failed: ${item}`);
        return;
      }
      if (this.previewToggles.length % TOGGLE_COLUMNS === 0) {
        // 需要新增一行，提前更新
        this.updatePreviewHeight(TOGGLE_HEIGHT + TOGGLE_ROWS_GAP);
        // 单列显示时往上滚动一格
        if (!this.showDoubleColumn) {
          this.scroller.scrollBy(0, TOGGLE_HEIGHT + TOGGLE_ROWS_GAP);
        }
        SysApiWrapper.setTimeout(() => {
          this.previewToggles.push(item);
        }, 150);
      } else {
        this.previewToggles.push(item);
      }
    });
  }

  private removeToggle(item: string, idx?: number) {
    TraceUtil.startTrace(DomainName.CC, 'removeToggle');
    if (this.previewToggles.length <= Constants.QUICK_TOGGLE_MIN) {
      log.showInfo('removeToggle less than 4')
      this.showToast?.(ResUtils.getInnerStringNumS($r('app.string.control_center_edit_panel_tips_min_toggles'),
        Constants.QUICK_TOGGLE_MIN));
      // 控制中心编辑快捷开关数量限制toast提示打点
      ControlCenterHiSysEventUtil.reportCCNumberSwitchToast({
        UPPERLOWERTHRESHOLDSSWITCHVALUE: LOWER_LIMIT,
        TOASTNUMBERSWITCHVALUE: Constants.QUICK_TOGGLE_MIN.toString(),
        TIMESTAMP: DropDownPanelManager.getLastDropdownTime().toString(),
      })
      TraceUtil.endTrace(DomainName.CC, 'removeToggle');
      AccessibilityUtil.sendAccessibility(AccessibilityUtilExt.getEditToggleReportText(this.previewToggles.length - 1,
        Constants.QUICK_TOGGLE_MAX, Constants.QUICK_TOGGLE_MIN, TOGGLE_COLUMNS, false));
      return;
    }
    ControlCenterHiSysEventUtil.reportCCEditRemoveQuickSwitch({
      TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      SWITCHNUMBER: this.previewToggles.length - 1,
      SWITCHNAME: item,
      SWITCHLOCATION: idx ? idx : 0,
    })
    SysApiWrapper.animateTo({
      duration: 250,
      onFinish: () => {
        TraceUtil.endTrace(DomainName.CC, 'removeToggle');
        AccessibilityUtil.sendAccessibility(AccessibilityUtilExt.getEditToggleReportText(this.previewToggles.length,
          Constants.QUICK_TOGGLE_MAX, Constants.QUICK_TOGGLE_MIN, TOGGLE_COLUMNS, false));
        AccessibilityUtil.requestFocusAccessibility('Ctrl.ToggleEditView_Remove_Btn');
      }
    }, () => {
      if (!this.removeItem(item, this.previewToggles)) {
        log.showError(`remove item from previewToggles failed: ${item}`);
        return;
      }
      let needUpdateHeight: boolean = (this.previewToggles.length % TOGGLE_COLUMNS) === 0;
      SysApiWrapper.setTimeout(() => {
        log.showInfo('insertToLibraryToggles and updatePreviewHeight');
        this.insertToLibraryToggles(item);
        if (!needUpdateHeight) {
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
        AccessibilityUtil.requestFocusAccessibility('Ctrl.ToggleEditView_Add_Btn');
      },
    }, () => {
      this.viewData.showQuickToggleLibrary = true;
      this.viewData.quickLibraryTrans = 0;
      this.updatePreviewHeight();
      if (!this.showDoubleColumn) {
        this.scrollBlurController?.activeScrollerBlur();
        this.scroller.scrollPage({ next: true });
      } else {
        this.scrollBlurController?.scrollToWithBlur(this.viewData.editTopPreviewPanelHeight + 14);
      }
    });
  }

  public updatePreviewHeight(extraHeight: number = 0): void {
    let rows = Math.floor(this.previewToggles.length / TOGGLE_COLUMNS);
    if (this.previewToggles.length % TOGGLE_COLUMNS > 0) {
      rows += 1;
    }
    let length = rows * TOGGLE_HEIGHT + (rows + 1) * TOGGLE_ROWS_GAP + extraHeight;
    if (!this.viewData.showQuickToggleLibrary) {
      length += TOGGLE_ROWS_GAP + ADD_BUTTON_HEIGHT + EXTRA_HEIGHT_IN_COMPACT_LAYOUT;
    }
    // 开关行数+亮度条
    this.viewData.editPreviewPanelHeight = length;
  }

  public onLongPressActionForDrag = (item: string) => {
    this.dragHelper.onLongPressActionForDrag(item);
  }
  public onLongPressActionEndForDrag = () => {
    this.dragHelper.onLongPressActionEndForDrag();
  };
  public onActionStartForDrag = (item: string) => {
    this.dragHelper.onActionStartForDrag(item);
  }
  public onActionUpdateForDrag = (event: GestureEvent) => {
    this.dragHelper.onActionUpdateForDrag(event);
  }
  public onActionEndForDrag = () => {
    if (this.viewData.dragItem !== '') {
      AccessibilityUtil.sendAccessibility(
        ControlCenterAccessibilityDataModel.getInstance().get(this.viewData.dragItem) +
        ResUtils.getInnerString($r('app.string.cc_accessibility_str_edit_move_end')) +
        AccessibilityUtilExt.getTogglePlaceItemText(TOGGLE_COLUMNS,
          this.previewToggles.indexOf(this.viewData.dragItem)));
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
}