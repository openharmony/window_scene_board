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

import { LogDomain, LogHelper, CheckEmptyUtils, singleManager } from '@ohos/basicutils';
import { KeyCodeConstants } from '@ohos/commonconstants';
import {
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneSessionManager
} from '@ohos/windowscene';
import { SCBRecentSessionsViewModel } from '../SCBRecentSessionsViewModel';
import { RecentFocusController } from './RecentFocusController';

const TAG = 'RecentFocusManager';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class RecentFocusManager {
  private static instance: RecentFocusManager | null = null;
  private screen2RecentFocusController: Map<number, RecentFocusController> = new Map<number, RecentFocusController>();
  private currentScreenId: number = SCBSceneSessionManager.getInstance().mainScreenId;
  private crossScreenFocusModel: CrossScreenFocusModel = new CrossScreenFocusModel();


  public getCurrentScreenId(): number {
    return this.currentScreenId;
  }

  public setCurrentScreenId(screenId: number): void {
    log.showInfo(`setCurrentScreenId, oldScreenId: ${this.currentScreenId}, newScreenId: ${screenId}`);
    this.currentScreenId = screenId;
  }

  public init(): void {
    this.initCurrentScreenId();
    this.initRecentFocus();
  }

  private initCurrentScreenId(): void {
    let screenId: number = SCBSceneSessionManager.getInstance().mainScreenId;
    let screenCnt: number = this.screen2RecentFocusController.size;
    while (screenCnt > 0) {
      const containerSessionList: SCBSceneContainerSessionArray = this.getContainerListByScreenId(screenId);
      screenCnt--;
      if (!containerSessionList.isEmpty()) {
        break;
      }
      screenId = this.getNextScreenId(screenId);
    }
    this.setCurrentScreenId(screenId);
    log.showInfo(`initCurrentScreenId ${screenId}`);
  }

  private initRecentFocus(): void {
    this.screen2RecentFocusController.forEach((controller) => {
      controller.resetSelectedIndex();
    })
  }

  /**
   * Obtains the RecentFocusManager data model object.
   *
   * @return RecentFocusManager
   */
  static getInstance(): RecentFocusManager {
    if (!RecentFocusManager.instance) {
      RecentFocusManager.instance = new RecentFocusManager();
    }
    return RecentFocusManager.instance;
  }

  /**
   * get RecentFocusController bind to screenId
   * @param screenId
   * @returns
   */
  public getFocusControllerByScreenId(screenId: number): RecentFocusController {
    let focusController: RecentFocusController | undefined = this.screen2RecentFocusController.get(screenId);
    if (CheckEmptyUtils.isEmpty(focusController)) {
      focusController = new RecentFocusController({ extendScreenId: screenId });
      this.screen2RecentFocusController.set(screenId, focusController);
      log.showInfo(`getFocusControllerByScreenId new create ${screenId}`);
    }
    return focusController as RecentFocusController;
  }

  private getPreCurrentScreenId(): number {
    return this.getPreviousScreenId(this.currentScreenId);
  }

  private getNextCurrentScreenId(): number {
    return this.getNextScreenId(this.currentScreenId);
  }

  /**
   * Obtains the next screen ID of the given screenId.
   * @param screenId
   */
  public getNextScreenId(screenId: number): number {
    let screenIds = Array.from(this.screen2RecentFocusController.keys());
    let nextIndex: number = -1;
    const index = screenIds.findIndex((id:number) => {
      return id === screenId;
    });
    nextIndex = index + 1;
    if (nextIndex >= screenIds.length) {
      nextIndex = 0;
    }
    log.showInfo('getNextScreenId，screenId: %{public}d, screenIds.length: %{public}d, nextScreenId: %{public}d',
      screenId, screenIds.length, screenIds[nextIndex]);
    return screenIds[nextIndex];
  }

  /**
   * Obtains the Previous screen ID of the given screenId.
   * @param screenId
   */
  public getPreviousScreenId(screenId: number): number {
    let screenIds = Array.from(this.screen2RecentFocusController.keys());
    let previousIndex: number = - 1;
    const index = screenIds.findIndex((id:number) => {
      return id === screenId;
    });
    previousIndex = index - 1;
    if (previousIndex < 0) {
      previousIndex = screenIds.length - 1;
    }
    log.showInfo('getPreviousScreenId,screenId: %{public}d, screenIds.length: %{public}d,' +
      'previousScreenId: %{public}d', screenId, screenIds.length, screenIds[previousIndex]);
    return screenIds[previousIndex];
  }

  /**
   * destroy the RecentFocusController
   * @param focusController
   */
  public destroyFocusController(focusController: RecentFocusController): void {
    if (CheckEmptyUtils.isEmpty(focusController)) {
      log.showError(`destroyFocusController controller is empty`);
      return;
    }
    log.showInfo(`destroyFocusController ScreenId: ${focusController.getScreenId()} ${this.currentScreenId}`);
    this.screen2RecentFocusController.delete(focusController.getScreenId());
    if (this.currentScreenId === focusController.getScreenId()) {
      this.initCurrentScreenId();
    }
  }

  /**
   * check the recent bind to screenId is responsive for focus
   * @param screenId
   * @returns
   */
  public isScreenFocusResponsive(screenId: number): boolean {
    return screenId === this.currentScreenId;
  }

  /**
   * whether cross-screen out-of-focus is supported
   * @returns
   */
  public isCrossScreenFocusable(): boolean {
    const size = this.screen2RecentFocusController.size;
    let screenIds = Array.from(this.screen2RecentFocusController.keys());
    let notEmptyScreenRecentCount = 0;
    screenIds.forEach((screenId) => {
      const containerSessionList: SCBSceneContainerSessionArray = this.getContainerListByScreenId(screenId);
      if (!containerSessionList.isEmpty()) {
        notEmptyScreenRecentCount++;
      }
    });
    log.showInfo(`crossScreenFocusAble size: ${size},NotEmptyScreenRecentCount: ${notEmptyScreenRecentCount}`);
    return size >= 2 && notEmptyScreenRecentCount >= 2;
  }

  /**
   * cross the focus to next screen recent, which behind the current screen
   */
  public crossFocusToNextScreenRecent(): void {
    const currentFocusController = this.getCurrentFocusController();
    const nextScreenId: number = this.getNextCurrentScreenId();
    const nextFocusController = this.getNextFocusController();
    nextFocusController.setRecentSelectedIndex(0);
    currentFocusController.resetSelectedIndex();
    this.setCurrentScreenId(nextScreenId);
    log.showInfo('crossFocusToNextScreenRecent, currentScreenId: %{public}d, nextScreenId: %{public}d,' +
      'nextSelectedIndex: %{public}d', this.currentScreenId, nextScreenId);
  }

  private getContainerListByScreenId(screenId: number): SCBSceneContainerSessionArray {
    return SCBRecentSessionsViewModel.getInstance({ extendScreenId: screenId }).getShowInRecentContainerSessionList();
  }
  /**
   * cross the focus to previous screen recent, which is previous to the current screen
   */
  public crossFocusToPreviousScreenRecent(): void {
    const previousScreenId: number = this.getPreCurrentScreenId();
    const previousRecentFocusController = this.getPreviousFocusController();
    const previousContainerSessionListLength: number = this.getContainerListByScreenId(previousScreenId).length;
    const currentFocusController = this.getCurrentFocusController();
    const previousSelectedIndex = previousContainerSessionListLength - 1;
    previousRecentFocusController.setRecentSelectedIndex(previousSelectedIndex);
    currentFocusController.resetSelectedIndex();
    this.setCurrentScreenId(previousScreenId);
    log.showInfo('crossFocusToPreviousScreenRecent, currentScreenId: %{public}d, previousScreenId: %{public}d,' +
      'previousSelectedIndex: %{public}d', this.currentScreenId, previousScreenId, previousSelectedIndex);
  }

  /**
   * cross the focus to the screen recent behind current screen by alt+tab key
   */
  public crossFocusToNextScreenRecentByAltTab(): void {
    let currentFocusController = this.getCurrentFocusController();
    let nextScreenId = this.getNextCurrentScreenId();
    let nextFocusController = this.getNextFocusController();
    currentFocusController.resetSelectedIndex();
    nextFocusController.setRecentSelectedIndex(0);
    this.setCurrentScreenId(nextScreenId);
    log.showInfo(`crossFocusToNextScreenRecentByAltTab, currentScreenId: ${this.currentScreenId}, nextScreenId: ${nextScreenId}`);
  }

  /**
   * get current focused index
   * @returns
   */
  public getCurrentSelectedIndex(): number {
    let curFocusController = this.getCurrentFocusController();
    log.showInfo(`getCurrentSelectedIndex, currentScreenId: ${this.currentScreenId}`);
    return curFocusController.getRecentSelectedIndex();
  }

  /**
   * set the current focused index
   * @returns
   */
  public setCurrentSelectedIndex(index: number): void {
    let curFocusController = this.getCurrentFocusController();
    log.showInfo(`setCurrentSelectedIndex, currentScreenId: ${this.currentScreenId}`);
    curFocusController.setRecentSelectedIndex(index);
  }

  /**
   * get the SCBSceneContainerSession corresponding to current focused index
   * @returns
   */
  public getCurrentSelectedItem(): SCBSceneContainerSession | null {
    let curFocusController = this.getCurrentFocusController();
    log.showInfo(`getCurrentSelectedItem, currentScreenId: ${this.currentScreenId}`);
    return curFocusController.getRecentSelectedItem();
  }

  /**
   * 判断是否处于跨屏走焦临界状态
   * @param selectedIndex
   * @param focusType
   * @returns
   */
  public isRecentCrossScreenFocus(selectedIndex: number, focusType: number): boolean {
    if (!this.isCrossScreenFocusable()) {
      return false;
    }
    if (this.isRecentCrossPreviousScreenFocus(selectedIndex, focusType) ||
      this.isRecentCrossNextScreenFocus(selectedIndex, focusType)) {
      return true;
    }
    return false;
  }

  /**
   * 是否是往上屏走焦
   * @param selectedIndex
   * @param focusType
   * @returns
   */
  public isRecentCrossPreviousScreenFocus(selectedIndex: number, focusType: number): boolean {
    return (selectedIndex === -1 || selectedIndex === 0) && focusType === KeyCodeConstants.KEYCODE_DPAD_LEFT;
  }
  /**
   * 是否是往下屏走焦
   * @param selectedIndex
   * @param focusType
   * @returns
   */
  public isRecentCrossNextScreenFocus(selectedIndex: number, focusType: number): boolean {
    let recentList = this.getContainerListByScreenId(this.currentScreenId);
    return selectedIndex === recentList.length - 1 &&
      focusType === KeyCodeConstants.KEYCODE_DPAD_RIGHT;
  }

  /**
   * 执行跨屏走焦
   * @param selectedIndex
   * @param focusType
   */
  public doChangeFocus(selectedIndex: number, focusType: number, screenId: number, focusCallBack: Function): void {

    if (!this.crossScreenFocusModel.isAvailable()) {
      this.crossScreenFocusModel.setScreenCnt(this.screen2RecentFocusController.size);
    }
    if (screenId === this.currentScreenId) {
      log.showInfo(`doChangeFocus ${selectedIndex}, ${focusType}, ${screenId}`);
      this.crossScreenFocusModel.init(selectedIndex, focusType, focusCallBack);
    }
    if (!this.crossScreenFocusModel.deScreenCountAndCheckFinish()) {
      log.showInfo(`doChangeFocus Traverse not finish  ${screenId}`);
      return;
    }
    if (this.isCrossScreenFocusable() && this.isRecentCrossPreviousScreenFocus(
      this.crossScreenFocusModel.getSelectedIndex(), this.crossScreenFocusModel.getFocusType())) {
      this.crossFocusToPreviousScreenRecent();
      this.crossScreenFocusModel.reset();
      return;
    }
    if (this.isCrossScreenFocusable() && this.isRecentCrossNextScreenFocus(
      this.crossScreenFocusModel.getSelectedIndex(), this.crossScreenFocusModel.getFocusType())) {
      this.crossFocusToNextScreenRecent();
      this.crossScreenFocusModel.reset();
      return;
    }
    const callBack = this.crossScreenFocusModel.getFocusCallBack();
    callBack(focusType);
    this.crossScreenFocusModel.reset();
  }

  private getCurrentFocusController(): RecentFocusController {
    log.showInfo(`getCurrentFocusController currentScreenId: ${this.currentScreenId}`);
    return this.getFocusControllerByScreenId(this.currentScreenId);
  }

  private getNextFocusController(): RecentFocusController {
    let nextScreenId = this.getNextCurrentScreenId();
    log.showInfo(`getNextFocusController nextScreenId: ${nextScreenId}`);
    return this.getFocusControllerByScreenId(nextScreenId);
  }

  private getPreviousFocusController(): RecentFocusController {
    let previousScreenId = this.getPreCurrentScreenId();
    log.showInfo(`getPreviousFocusController previousScreenId: ${previousScreenId}`);
    return this.getFocusControllerByScreenId(previousScreenId);
  }

  /**
   * 判断该container是否是预分屏场景里的上下二分屏窗口
   * @param containerSession
   * @returns
   */
  public isSplitRecentUpAndDownContainer(containerSession: SCBSceneContainerSession): boolean {
    let result: boolean = false;
    if (!containerSession) {
      return result;
    }
    if (containerSession.dividerParam?.isSplitRecentPair &&
    containerSession.secondarySession && containerSession.dividerParam?.isExpandUpDownSplit()) {
      result = true;
    }
    log.showInfo(`isSplitRecentUpAndDownContainer %{public}s, %{public}s`,
      containerSession.getName(), result);
    return result;
  }

}

export class CrossScreenFocusModel {
  private screenCnt: number = -1;
  private selectedIndex: number = -1;
  private focusType: number = -1;
  private focusCallBack: Function = () => {};

  /**
   * 设置焦点索引值和屏幕类型
   * @param selectedIndex
   * @param focusType
   */
  public init(selectedIndex: number, focusType: number, focusCallBack: Function): void {
    this.setSelectedIndex(selectedIndex);
    this.setFocusType(focusType);
    this.setFocusCallBack(focusCallBack);
  }

  /**
   * 重置数据
   */
  public reset(): void {
    this.screenCnt = -1;
    this.selectedIndex = -1;
    this.focusType = -1;
    this.focusCallBack = () => {};
  }

  /**
   * screenCnt减1，并判断遍历是否完成
   * @returns
   */
  public deScreenCountAndCheckFinish(): boolean {
    this.screenCnt--;
    return this.screenCnt === 0;
  }

  /**
   * 判断是否可用
   * @returns
   */
  public isAvailable(): boolean {
    return this.screenCnt != -1;
  }

  /**
   * 设置焦点索引值
   * @param value
   */
  public setSelectedIndex(value: number) {
    this.selectedIndex = value;
  }

  /**
   * 获取焦点索引值
   */
  public getSelectedIndex(): number {
    return this.selectedIndex;
  }

  /**
   * 设置走焦类型
   * @param value
   */
  public setFocusType(value: number) {
    this.focusType = value;
  }

  /**
   * 获取走焦类型
   * @returns
   */
  public getFocusType(): number {
    return this.focusType;
  }

  /**
   * 设置屏幕的数量
   * @param value
   */
  public setScreenCnt(value: number) {
    this.screenCnt = value;
  }

  /**
   * 获取屏幕的数量
   */
  public getScreenCnt(): number {
    return this.screenCnt;
  }

  /**
   * 设置屏幕内部走焦回调
   * @param value
   */
  public setFocusCallBack(callBack: Function) {
    this.focusCallBack = callBack;
  }

  /**
   * 获取屏幕内部走焦回调
   */
  public getFocusCallBack(): Function {
    return this.focusCallBack;
  }

}

