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

import { LogDomain, LogHelper, } from '@ohos/basicutils';
import { AppItemInfo, } from '@ohos/launchercommon';
import { dragController } from '@kit.ArkUI';
import { FoldedDeviceAcViewModel } from '../folded/FoldedDeviceAcViewModel';
import { CommonAcDragMgr } from './CommonAcDragMgr';
import { FoldedAcDragMgr } from '../folded/FoldedAcDragMgr';
import { SCBScreenProperty } from '@ohos/windowscene'

const TAG = 'AppCenterDragMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class AppCenterDragMgr {
  private static sInstance: AppCenterDragMgr;
  private mDragImpl: CommonAcDragMgr;

  private constructor() {
    log.showInfo('constructor');
    if (FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
      this.mDragImpl = new FoldedAcDragMgr();
    } else {
      this.mDragImpl = new CommonAcDragMgr();
    }
  }

  public static getInstance(): AppCenterDragMgr {
    if (!AppCenterDragMgr.sInstance) {
      AppCenterDragMgr.sInstance = new AppCenterDragMgr();
    }
    return AppCenterDragMgr.sInstance;
  }

  public isInDragging(): boolean {
    return this.mDragImpl.isInDragging();
  }

  public setDragSnapshotRelativeRect(rect: Rectangle): void {
    return this.mDragImpl.setDragSnapshotRelativeRect(rect);
  }

  /**
   * 更新应用中心拖拽相关参数，拓展屏拖拽适配
   */
  public updateAppCenterDragData(screenId?: number, isChange?: boolean, width?: number, height?: number): void {
    this.mDragImpl.updateAppCenterDragData(screenId, isChange, width, height);
  }

  /**
   * 更新应用列表信息
   */
  public updateAppCenterLayoutInfo(scene: number, reason?: number): void {
    this.mDragImpl.updateAppCenterLayoutInfo(scene, reason);
  }

  public setIconRadius(iconRadius: number): void {
    this.mDragImpl.setIconRadius(iconRadius);
  }

  public setWhiteBoxState(state: boolean): void {
    this.mDragImpl.setWhiteBoxState(state);
  }

  public setDragItemInfo(item: AppItemInfo): void {
    this.mDragImpl.setDragItemInfo(item);
  }

  public getDragItemInfo(): AppItemInfo {
    return this.mDragImpl.getDragItemInfo();
  }

  public setAppCenterViewShow(isShow: boolean): void {
    this.mDragImpl.setAppCenterViewShow(isShow);
  }

  public getAppCenterViewShow(): boolean {
    return this.mDragImpl.getAppCenterViewShow();
  }

  public resetLastMovPosIfDragLeave(): void {
    this.mDragImpl.resetLastMovPosIfDragLeave();
  }

  /**
   * 是否拖拽元素
   * @param item
   * @returns
   */
  public isDragItem(item: AppItemInfo): boolean {
    return this.mDragImpl.isDragItem(item);
  }

  /**
   * 判断两个appItem是否相同
   * @param itemA
   * @param itemB
   * @returns
   */
  public checkAppItemEqual(itemA: AppItemInfo, itemB: AppItemInfo): boolean {
    return this.mDragImpl.checkAppItemEqual(itemA, itemB);
  }

  /**
   * 起拖
   * @param event
   * @param item
   */
  public onDragStart(event: DragEvent, item?: AppItemInfo, screenProp?: SCBScreenProperty): void {
    this.mDragImpl.onDragStart(event, item, screenProp);
  }

  /**
   * 拖拽结束
   * @param event
   */
  public onDragEnd(event?: DragEvent, screenId?: number): void {
    this.mDragImpl.onDragEnd(event, screenId);
  }

  /**
   * 落位
   */
  public onDrop(context?: UIContext, screenProp?: SCBScreenProperty): void {
    this.mDragImpl.onDrop(context, screenProp);
  }

  /**
   * 中断重置
   * @param event
   */
  public onDragCancel(): void {
    this.mDragImpl.onDragCancel();
  }

  /**
   * 拖拽移动
   * @param event
   * @param callback
   */
  public onDragMove(event: DragEvent, callback?: Function, context?: UIContext, screenId?: number): void {
    this.mDragImpl.onDragMove(event, callback, context, screenId);
  }

  /**
   * 拖拽进入当前区域
   */
  public onDragEnter(screenProp?: SCBScreenProperty): void {
    this.mDragImpl.onDragEnter(screenProp);
  }

  /**
   * 拖拽离开当前区域
   */
  public onDragLeave(): void {
    this.mDragImpl.onDragLeave();
  }

  /**
   * 更新当前拖拽到达页
   * @param index
   */
  public setDragPageIndex(index: number): void {
    this.mDragImpl.setDragPageIndex(index);
  }

  public setIsSwaggingPage(isSwaggingPage: boolean): void {
    this.mDragImpl.setIsSwaggingPage(isSwaggingPage);
  }

  public getIsSwaggingPage(): boolean {
    return this.mDragImpl.getIsSwaggingPage();
  }

  /**
   * 落位动画结束
   * @param allowEnd 是否允许无动画结束
   */
  public onDropAnimationEnd(allowEnd: boolean = false): void {
    this.mDragImpl.onDropAnimationEnd(allowEnd);
  }

  public initCurrentMouse() {
    this.mDragImpl.initCurrentMouse();
  }

  /**
   * 是否正在动画中
   */
  public isAnimating(): boolean {
    return this.mDragImpl.isAnimating();
  }

  /**
   * 更新dragPageIndex
   * @param showNext true 下一页，false 上一页
   */
  public updateDragPageIndex(showNext: boolean): void {
    this.mDragImpl.updateDragPageIndex(showNext);
  }

  /**
   * 设置跨屏拖拽
   * @param crossScreen true 跨屏
   */
  public setDragCrossScreen(crossScreen: boolean = true): void {
    this.mDragImpl.setDragCrossScreen(crossScreen);
  }

  public getDragCrossScreen(): boolean {
    return this.mDragImpl.getDragCrossScreen();
  }

  public setDraggingCrossScreen(draggingCrossScreen: boolean = true): void {
    this.mDragImpl.setDraggingCrossScreen(draggingCrossScreen);
  }

  public setCrossFullPage(crossFullPage: boolean = false): void {
    this.mDragImpl.setCrossFullPage(crossFullPage);
  }

  /**
   * 获取起拖页面
   * @returns
   */
  public getStartDragPage(): number | undefined {
    return this.mDragImpl.getStartDragPage();
  }

  public getDraggingPageIndex(): number {
    return this.mDragImpl.getDraggingPageIndex();
  }
  /**
   * 获取起拖坐标
   * @returns
   */
  public getStartDragPos(screenId?: number): number[] {
    return this.mDragImpl.getStartDragPos(screenId);
  }

  /**
   * 是否在应用中心可拖拽区域内
   * @returns
   */
  public getCurrentIsInAppCenterWorkBench(screenId?: number): boolean {
    return this.mDragImpl.getCurrentIsInAppCenterWorkBench(screenId);
  }

  /**
   * 移除落位动画
   */
  public removeDropAnim(): void {
    return this.mDragImpl.removeDropAnim();
  }
  public getAppGridListByPage(pageIndex: number): AppItemInfo[] {
    return this.mDragImpl.getAppGridListByPage(pageIndex);
  }
  public getDragRefreshPageEventKey(pageIndex: number): string {
    return this.mDragImpl.getDragRefreshPageEventKey(pageIndex);
  }
}