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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import accessibility from '@ohos.accessibility';
import { AccessibilityManager } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { BusinessError } from '@ohos.base';


const TAG = 'DragAccessibilityUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 桌面组件拖拽适配无障碍朗读工具类
 */
export class DragAccessibilityUtils {
  private static beforeFolderIndex: number[] = [];
  private static beforeDesktopIndex: number[] = [];
  private static beforeCurDesktopIndex: number[] = [];
  private static beforeDockIndex: number = 0;
  private static beforeDockCurIndex: number = 0;

  /**
   * 判断是否处于无障碍模式
   * @returns
   */
  public static isAccessibilityMode(): boolean {
    return AccessibilityManager.getInstance().getIsAccessibilityMode();
  }

  /**
   * 无障碍模式播报已拖起（纯文本）
   */
  public static textAnnouncedForDragStart(): void {
    if (this.isAccessibilityMode()) {
      let announcedText: string = ResUtils.getInnerStringNumS($r('app.string.drag_start'));
      this.sendAccessibilityText(announcedText, 'textAnnouncedForDragStart');
    }
  }

  /**
   * 无障碍模式播报已拖起（多选拖拽）
   */
  public static textAnnouncedForMultiDragStart(selectNum: number): void {
    if (this.isAccessibilityMode()) {
      let announcedText: string = ResUtils.getInnerPluralByResource($r('app.plural.multiSelect_drag_start'), selectNum);
      this.sendAccessibilityText(announcedText, 'textAnnouncedForMultiDragStart');
    }
  }

  /**
   * dock区已满播报（纯文本）
   */
  public static textAnnouncedForDockIsFull(): void {
    if (this.isAccessibilityMode()) {
      let announcedText: string = ResUtils.getInnerStringNumS($r('app.string.drag_drop_dock_full'));
      this.sendAccessibilityText(announcedText, 'textAnnouncedForDockIsFull');
    }
    this.restore();
  }

  /**
   * 靠近屏幕右边缘（纯文本）
   */
  public static textAnnouncedForNearRight(): void {
    let announcedText: string = ResUtils.getInnerStringNumS($r('app.string.drag_near_right_screen'));
    this.sendAccessibilityText(announcedText, 'textAnnouncedForNearRight');
  }

  /**
   * 靠近屏幕左边缘（纯文本）
   */
  public static textAnnouncedForNearLeft(): void {
    let announcedText: string = ResUtils.getInnerStringNumS($r('app.string.drag_near_left_screen'));
    this.sendAccessibilityText(announcedText, 'textAnnouncedForNearLeft');
  }

  /**
   * 无障碍模式拖动场景播报，落位为桌面
   * @param fallIndex 实际落位位置
   * @param currentIndex 当前拖拽的位置
   */
  public static textAnnouncedForDragMoveToDesktop(fallIndex: number[], currentIndex: number[]): void {
    // 落位点变化或者当前位置变化，则进行播报
    if (this.beforeDesktopIndex.length !== 0 && this.beforeCurDesktopIndex.length !== 0 &&
      (fallIndex[0] !== this.beforeDesktopIndex[0] || fallIndex[1] !== this.beforeDesktopIndex[1] ||
        currentIndex[0] !== this.beforeCurDesktopIndex[0] || currentIndex[1] !== this.beforeCurDesktopIndex[1])) {
      log.showInfo(`textAnnouncedForDragMoveToDesktop currenntIndex: ${currentIndex}`);
      let announcedText: string = ResUtils.getInnerStringNumS($r('app.string.drag_move'), String(fallIndex[0]),
        String(fallIndex[1]));
      this.sendAccessibilityText(announcedText, 'textAnnouncedForDragMoveToDesktop');
    }
    this.beforeDesktopIndex = fallIndex;
    this.beforeCurDesktopIndex = currentIndex;
  }

  /**
   * 无障碍模式拖动场景播报，场景为文件夹打开状态
   * @param fallIndex 实际落位位置
   * @param currentIndex 当前拖拽的位置
   */
  public static textAnnouncedForDragMoveInFolder(fallIndex: number[], currentIndex: number[]): void {
    if (this.beforeFolderIndex.length !== 0 &&
      (this.beforeFolderIndex[0] !== currentIndex[0] || this.beforeFolderIndex[1] !== currentIndex[1])) {
      log.showInfo(`textAnnouncedForDragMoveInFolder currenntIndex: ${currentIndex}`);
      let announcedText: string = ResUtils.getInnerStringNumS($r('app.string.drag_move'), String(fallIndex[0]),
        String(fallIndex[1]));
      this.sendAccessibilityText(announcedText, 'textAnnouncedForDragMoveInFolder');
    }
    this.beforeFolderIndex = currentIndex;
  }

  /**
   * 无障碍模式拖动场景播报，落位为dock区域
   * @param fallIndex 实际落位位置
   * @param currentIndex 当前拖拽的位置
   */
  public static textAnnouncedForDragMoveToDock(fallIndex: number, currentIndex: number): void {
    if (this.isAccessibilityMode()) {
      if (fallIndex > 0 && this.beforeDockIndex !== 0 && this.beforeDockCurIndex !== 0 &&
        (this.beforeDockCurIndex !== currentIndex || this.beforeDockIndex !== fallIndex)) {
        log.showInfo(`textAnnouncedForDragMoveToDock currentIndex: ${currentIndex}`);
        let announcedText: string = ResUtils.getInnerStringNumS($r('app.string.drag_move_to_dock'),
          String(fallIndex));
        this.sendAccessibilityText(announcedText, 'textAnnouncedForDragMoveToDock');
      }
      this.beforeDockCurIndex = currentIndex;
      this.beforeDockIndex = fallIndex;
    }
  }

  /**
   * 当拖动的应用覆盖应用时的播报
   * @param coveredName 覆盖的图标名称
   */
  public static textAnnouncedForMoveToMerge(coveredName: string): void {
    if (this.isAccessibilityMode()) {
      this.resetIndex();
      let announcedText: string = '';
      announcedText = ResUtils.getInnerStringNumS($r('app.string.drag_move_to_merge'), coveredName);
      this.sendAccessibilityText(announcedText, 'textAnnouncedForMoveToMerge');
    }
  }

  /**
   * 当拖动的应用覆盖文件夹时的播报
   * @param coveredName 覆盖的图标名称
   */
  public static textAnnouncedForMoveToFolder(coveredName: string): void {
    if (this.isAccessibilityMode()) {
      this.resetIndex();
      let announcedText: string = '';
      announcedText = ResUtils.getInnerStringNumS($r('app.string.drag_move_to_folder'), coveredName);
      this.sendAccessibilityText(announcedText, 'textAnnouncedForMoveToFolder');
    }
  }

  /**
   * 当拖动的应用覆盖卡片时的播报
   * @param coveredName 覆盖的图标名称
   */
  public static textAnnouncedForMoveToMergeCard(coveredName: string): void {
    if (this.isAccessibilityMode()) {
      let announcedText: string = '';
      announcedText = ResUtils.getInnerStringNumS($r('app.string.drag_move_to_merge_card'), coveredName);
      this.sendAccessibilityText(announcedText, 'textAnnouncedForMoveToFolder');
    }
  }

  /**
   * 当拖动的应用覆盖堆叠时的播报
   * @param coveredName 覆盖的图标名称
   */
  public static textAnnouncedForMoveToFormStack(coveredName: string): void {
    if (this.isAccessibilityMode()) {
      let announcedText: string = '';
      announcedText = ResUtils.getInnerStringNumS($r('app.string.drag_move_to_form_stack'), coveredName);
      this.sendAccessibilityText(announcedText, 'textAnnouncedForMoveToFolder');
    }
  }

  /**
   * 落位到桌面上/dock栏上/文件夹里
   * @param fallIndex 落位位置
   * @param dragItemName 拖起图标名称
   */
  public static textAnnouncedForDrop(fallIndex: number | number[], dragItemName: string): void {
    if (this.isAccessibilityMode()) {
      let announcedText: string = this.getDropAnnouncedText(fallIndex, dragItemName);
      this.sendAccessibilityText(announcedText, 'textAnnouncedForDrop');
      this.restore();
    }
  }

  private static getDropAnnouncedText(fallIndex: number | number[], coveredName: string): string {
    let announcedText:string = '';
    if (typeof fallIndex === 'number') {
      announcedText = ResUtils.getInnerStringNumS($r('app.string.drag_drop_to_dock'), coveredName,
        String(fallIndex));
    } else {
      announcedText = ResUtils.getInnerStringNumS($r('app.string.drag_drop'), coveredName, String(fallIndex[0]),
        String(fallIndex[1]));
    }
    return announcedText;
  }

  /**
   * 多选拖拽落位播报
   * @param selectNum 被拖起的应用数量
   */
  public static textAnnouncedForMultiDrop(selectNum: number): void {
    if (this.isAccessibilityMode()) {
      let announcedText: string = ResUtils.getInnerPluralByResource($r('app.plural.multiSelect_drag_drop'), selectNum);
      this.sendAccessibilityText(announcedText, 'textAnnouncedForMultiDrop');
      this.restore();
    }
  }

  /**
   * 桌面上合并文件夹
   */
  public static textAnnouncedForDropMergeToDesktop(dragAppName: string, coveredName: string, folderName: string,
    fallIndex: number[]): void {
    if (this.isAccessibilityMode()) {
      let announcedText: string = '';
      announcedText = ResUtils.getInnerStringNumS($r('app.string.drop_merge_to_desktop'), dragAppName, coveredName,
        folderName, String(fallIndex[0]), String(fallIndex[1]));
      this.sendAccessibilityText(announcedText, 'textAnnouncedForDropMergeToDesktop');
      this.restore();
    }
  }

  /**
   * dock栏上合并文件夹
   */
  public static textAnnouncedForDropMergeToDock(dragAppName: string, coveredName: string, folderName: string,
    fallIndex: number): void {
    if (this.isAccessibilityMode()) {
      let announcedText: string = '';
      announcedText = ResUtils.getInnerStringNumS($r('app.string.drop_merge_to_dock'), dragAppName, coveredName,
        folderName, String(fallIndex));
      this.sendAccessibilityText(announcedText, 'textAnnouncedForDropMergeToDock');
      this.restore();
    }
  }

  /**
   * 应用移至文件夹
   */
  public static textAnnouncedForDropToFolder(dragAppName: string, coveredName: string): void {
    if (this.isAccessibilityMode()) {
      let announcedText: string = '';
      announcedText = ResUtils.getInnerStringNumS($r('app.string.drag_drop_to_folder'), dragAppName, coveredName);
      this.sendAccessibilityText(announcedText, 'textAnnouncedForDropToFolder');
      this.restore();
    }
  }

  /**
   * 卡片合并为堆叠卡片
   */
  public static textAnnouncedForDropMergeToFormStack(dragItemName: string, coveredName: string): void {
    if (this.isAccessibilityMode()) {
      let announcedText: string = '';
      announcedText = ResUtils.getInnerStringNumS($r('app.string.drop_merge_to_form_stack'), dragItemName, coveredName);
      this.sendAccessibilityText(announcedText, 'textAnnouncedForDropMergeToDock');
      this.restore();
    }
  }

  /**
   * 卡片移至堆叠卡片
   */
  public static textAnnouncedForDropToFormStack(dragItemName: string, coveredName: string): void {
    if (this.isAccessibilityMode()) {
      let announcedText: string = '';
      announcedText = ResUtils.getInnerStringNumS($r('app.string.drag_drop_to_form_stack'), dragItemName, coveredName);
      this.sendAccessibilityText(announcedText, 'textAnnouncedForDropToFolder');
      this.restore();
    }
  }

  private static restore(): void {
    this.beforeFolderIndex = [];
    this.beforeDesktopIndex = [];
    this.beforeCurDesktopIndex = [];
    this.beforeDockIndex = 0;
    this.beforeDockCurIndex = 0;
  }

  /**
   * 在无障碍模式下主动播报信息
   * @param textAnnouncedForAccessibility  播报的信息
   * @param from  播报来自哪里
   */
  private static sendAccessibilityText(textAnnouncedForAccessibility: string, from: string): void {
    let accessEventInfo: accessibility.EventInfo = ({
      type: 'announceForAccessibility',
      bundleName: 'com.ohos.sceneboard',
      triggerAction: 'common',
      textAnnouncedForAccessibility: '',
    });
    accessEventInfo.textAnnouncedForAccessibility = textAnnouncedForAccessibility;
    log.showInfo(`%{public}s sendAccessibilityText textAnnouncedForAccessibility %{public}s`,
      from, accessEventInfo.textAnnouncedForAccessibility);
    try {
      accessibility.sendAccessibilityEvent(accessEventInfo, (err: BusinessError) => {
        if (err) {
          log.showError(`failed to send event, Code is ${err.code}, message is ${err.message}`);
          return;
        }
        log.showInfo(`Succeeded in send event, eventInfo is ${accessEventInfo}`);
      });
    } catch (error) {
      log.showError('sendAccessibilityEvent failed');
    }
  }

  /**
   * 离开当前区域时，需要重置beforeIndex的值，但不是初始值，防止第一次进入其他区域出现不播报位置的情况
   */
  public static resetIndex(): void {
    this.beforeDesktopIndex = [-1, -1];
    this.beforeCurDesktopIndex = [-1, -1];
    this.beforeDockIndex = -1;
    this.beforeDockCurIndex = -1;
  }
}