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
import { DragEventManager } from '@ohos/componentdrag';
import { SwiperLoadData } from '@ohos/swiperdata';
import { CommonConstants, EditModeUtils, GridLayoutUtil } from '../../TsIndex';
import { DisplayCountViewModel } from '../../displaycount/DisplayCountViewModel';

const TAG = 'PageDragManager';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class PageDragManager {
  private static instance?: PageDragManager;
  private static outerInstance?: PageDragManager;
  private draggingPage: number[] = [];
  private squeezingPage: Set<number> = new Set();
  private translate: number = 0;
  private direction: number = 0;
  private isOuterDeskTop: boolean = false;

  /**
   * 获取单例类
   */
  public static getInstance(): PageDragManager {
      if (!PageDragManager.instance) {
        PageDragManager.instance = new PageDragManager();
      }
      return PageDragManager.instance;
  }

  public setOuterDeskTop(isOuter: boolean) {
    this.isOuterDeskTop = isOuter;
  }

  /**
   * 获取拖拽页面
   */
  public getDraggingPage(): number[] {
    return this.draggingPage;
  }

  /**
   * 拖拽开始通知事件
   */
  public onDragStartEvent(): void {
    animateToImmediately({
      duration: 0,
    }, () => {
      this.draggingPage.forEach((index: number) => {
        DragEventManager.getInstance(this.isOuterDeskTop).dragStartInDesktop(this.getPageUniqueKey(index));
      });
    });
    log.showInfo('page: %{public}s is dragging', this.draggingPage.toString());
  }

  /**
   * 拖拽结束通知事件
   */
  public onDragEndEvent(): void {
    // 仅做兜底处理，强制清空已挤位页面偏移量，不能依赖该方法清除偏移量，需手动调用cancelSqueeze接口
    if (this.squeezingPage.size !== 0) {
      log.showWarn('dragEnd with squeezed pages: %{public}d', this.squeezingPage.size);
      this.onCancelSqueezeEvent(false);
    }
    this.draggingPage.forEach((index: number) => {
      DragEventManager.getInstance(this.isOuterDeskTop).dropEnd(this.getPageUniqueKey(index));
    });
    this.draggingPage = [];
  }

  /**
   * 拖拽挤位通知事件
   * @param pageIndex 目标索引
   */
  public onDragSqueezeEvent(pageIndex: number): void {
    if (this.draggingPage.includes(pageIndex)) {
      log.showInfo('drag back to start page: %{public}d', pageIndex);
      this.onCancelSqueezeEvent(true);
      return;
    }

    const squeezeForward: boolean = pageIndex > this.draggingPage[0];
    this.initSqueezeInfo(squeezeForward);
    const showingPages: number[] = this.getRelativePages(pageIndex);
    const startPage: number = squeezeForward ? this.draggingPage[this.draggingPage.length - 1] + 1 : showingPages[0];
    const endPage: number = squeezeForward ? showingPages[showingPages.length - 1] : this.draggingPage[0] - 1;
    // 初始化新待挤位元素列表
    let squeezePages: Set<number> = new Set();
    for (let i = startPage; i <= endPage; i++) {
      squeezePages.add(i);
    }
    squeezePages.forEach((index: number) => {
      // 新待挤位列表中元素未触发过挤位时，需执行挤位
      if (!this.squeezingPage.has(index)) {
        this.onPageSqueeze(index);
        return;
      }
      // 新待挤位列表中元素触发过挤位时，无须再次挤位
      this.squeezingPage.delete(index);
    });
    // 旧挤位列表中多余元素需要复原，拖拽过程中复原需要动效
    this.squeezingPage.forEach((index: number) => {
      this.onPageCancelSqueeze(index, true);
    });
    this.squeezingPage = squeezePages;
    log.showInfo('page: %{public}d-%{public}d is drag-squeezing', startPage, endPage);
  }

  /**
   * 编辑挤位通知事件
   * @param pageIndex 当前索引
   * @param add 是否为新增页
   */
  public onEditSqueezeEvent(pageIndex: number, isDelete: boolean): void {
    this.initSqueezeInfo(isDelete);
    const pageCount: number = SwiperLoadData.getInstance().getPages().length;
    // 添加页面时仅加号页需要动效
    let startPage: number = pageCount;
    let endPage: number = pageCount;
    // 删除页面时仅可视范围内的页面需要动效，最多只有当前页显示页面及后续两整屏需要动效
    if (isDelete) {
      let disCount: number = DisplayCountViewModel.getInstance().getDisplayCount();
      const showingPages: number[] = this.getRelativePages(pageIndex);
      startPage = isDelete ? showingPages[showingPages.length - 1] + 1 : showingPages[0];
      endPage = Math.min(pageCount, startPage - 1 + disCount * 2);
    }
    // 初始化新待挤位元素列表
    let squeezePages: Set<number> = new Set();
    // 添加页也需要动效，实际布局中不存在endPage页，通过取到endPage统一处理
    for (let i = startPage; i <= endPage; i++) {
      squeezePages.add(i);
    }
    squeezePages.forEach((index: number) => {
      this.onPageSqueeze(index);
    });
    this.squeezingPage = squeezePages;
    log.showInfo('page: %{public}d-%{public}d is edit-squeezing', startPage, endPage);
  }

  /**
   * 挤位取消通知事件
   * @param withAnimation 是否需要动效
   */
  public onCancelSqueezeEvent(withAnimation: boolean): void {
    this.squeezingPage.forEach((index: number) => {
      this.onPageCancelSqueeze(index, withAnimation);
    });
    this.squeezingPage.clear();
  }

  /**
   * 初始化拖拽信息
   * @param index 拖拽页码
   */
  public initDragInfo(index: number): void {
    this.draggingPage = this.getRelativePages(index);
  }

  /**
   * 初始化挤位信息
   * @param forward 是否前向挤位
   */
  public initSqueezeInfo(forward: boolean): void {
    this.direction = forward ? -1 : 1;
    this.translate = AppStorage.get<number>('screenWidth') as number - 2 * EditModeUtils.getPrevNextMargin();
  }

  private onPageSqueeze(index: number): void {
    const translate: number[][] = [[0], [this.translate * this.direction]];
    DragEventManager.getInstance(this.isOuterDeskTop).startSqueezedInDesktop(this.getPageUniqueKey(index), translate);
  }

  private onPageCancelSqueeze(index: number, withAnimation: boolean): void {
    DragEventManager.getInstance(this.isOuterDeskTop)
      .cancelSqueezedInDesktop(this.getPageUniqueKey(index), withAnimation);
  }

  /**
   * 获取与目标索引一起显示的所有页面
   */
  public getRelativePages(index: number): number[] {
    let displayCount = DisplayCountViewModel.getInstance().getDisplayCountData().getDisplayCount();
    const pageIndex: number = Math.floor(index / displayCount) * displayCount;
    const pages: number[] = [];
    for (let i = 0; i < displayCount; i++) {
      pages.push(pageIndex + i);
    }
    return pages;
  }

  /**
   * 获取页面唯一标识符
   */
  public getPageUniqueKey(index: number) {
    const swiperKey: number = SwiperLoadData.getInstance().getSwiperKeyByIndex(index);
    if (this.isOuterDeskTop) {
        return `${CommonConstants.SWIPER_GRID_WORKSPACE_TAG}${swiperKey}_OuterDesktop`;
    }
    return `${CommonConstants.SWIPER_GRID_WORKSPACE_TAG}${swiperKey}`;
  }
}


