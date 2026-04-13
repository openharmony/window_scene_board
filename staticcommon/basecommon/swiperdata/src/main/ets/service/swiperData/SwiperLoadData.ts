/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * 管理GridSwiper中pages页面信息,该信息用于创建和销毁SwiperPage页面
 */
export class SwiperLoadData {
  private static instance: SwiperLoadData = new SwiperLoadData();
  private static outerDesktopInstance: SwiperLoadData;
  // 只对外读取
  private pages: Array<number> = new Array();
  private maxValue: number = 0;

  private constructor() {
  }

  /**
   * 获取pages当前所有页面信息数据
   *
   * @returns pages返回的页面信息
   */
  public getIndexBySwiperKey(swiperKey: number): number {
    let index: number = 0;
    for (index = 0; index < this.pages.length; index++) {
      if (this.pages[index] === swiperKey) {
        return index;
      }
    }
    return -1;
  }

  /**
   * 获取pages当前所有页面信息数据
   *
   * @returns pages返回的页面信息
   */
  public getSwiperKeyByIndex(index: number): number {
    if (index >= this.pages.length) {
      return -1;
    }
    return this.pages[index];
  }

  /**
   * 获取Neighbor页的SwiperKey
   *
   * @param SwiperKey 查询的SwiperKey
   * @returns Neighbor页的SwiperKey
   */
  public getNeighborSwiperKey(SwiperKey: number): number {
    let index: number = this.getIndexBySwiperKey(SwiperKey);
    let neighborIndex: number = (index % 2 === 0 ? index + 1 : index - 1);
    return this.pages[neighborIndex];
  }


  /**
   * 获取pages当前所有页面信息数据
   *
   * @returns pages返回的页面信息
   */
  public getPages(): number[] {
    return this.pages.slice(0);
  }

  private updatePageMaxValue(): void {
    this.pages.forEach((item: number) => {
      this.maxValue = this.maxValue > item ? this.maxValue : item;
    });
    this.maxValue++;
  }

  /**
   * 获取当前最大的swiperKey
   *
   * @returns 当前最大的swiperKey
   */
  public getPageMaxValue(): number {
    this.pages.forEach((item: number) => {
      this.maxValue = Math.max(this.maxValue, item);
    });
    return this.maxValue;
  }

  /**
   * 对SwiperLoadData中的pages插入空白页操作
   *
   * @param addedPageIndex 插入起始位置
   * @param pageNumber 插入数量
   * @returns 添加的最后一个页面的key值，如果式非中间页面则不处理返回一个非法swiperKey
   */
  public addBlankPageMiddle(addedPageIndex: number, pageNumber: number): number {
    if (addedPageIndex + 1 > this.pages.length) {
      return -2;
    }
    this.updatePageMaxValue();
    if (pageNumber === 3) {
      this.pages.splice(addedPageIndex + 1, 0, this.maxValue, this.maxValue + 1, this.maxValue + 2);
      return this.maxValue + 2;
    }
    this.pages.splice(addedPageIndex + 1, 0, this.maxValue);

    if (pageNumber === 2) {
      this.updatePageMaxValue();
      this.pages.splice(addedPageIndex + 2, 0, this.maxValue);
    }
    return this.maxValue;
  }

  /**
   * 对SwiperLoadData中的pages拖拽操作
   *
   * @param startDragPageIndex 拖拽起始位置
   * @param endDragPageIndex 拖拽终点位置
   * @param pageNumber 拖拽数量
   */
  public dragPage(startDragPageIndex: number, endDragPageIndex: number, pageNumber: number): void {
    let newPages = [];
    if (startDragPageIndex > endDragPageIndex) {
      const before = this.pages.slice(0, endDragPageIndex);
      const squeeze = this.pages.slice(endDragPageIndex, startDragPageIndex);
      const drag = this.pages.slice(startDragPageIndex, startDragPageIndex + pageNumber);
      const after = this.pages.slice(startDragPageIndex + pageNumber);
      newPages = before.concat(drag).concat(squeeze).concat(after);
    } else {
      const before = this.pages.slice(0, startDragPageIndex);
      const squeeze = this.pages.slice(startDragPageIndex + pageNumber, endDragPageIndex + pageNumber);
      const drag = this.pages.slice(startDragPageIndex, startDragPageIndex + pageNumber);
      const after = this.pages.slice(endDragPageIndex + pageNumber);
      newPages = before.concat(squeeze).concat(drag).concat(after);
    }
    this.pages = newPages;
  }

  /**
   * 对SwiperLoadData中的pages删除空白页操作
   *
   * @param deletedPageIndex 删除起始位置
   * @param pageNumber 删除数量
   */
  public deleteBlankPageMiddle(deletedPageIndex: number, deletedPageCount: number): void {
    this.pages.splice(deletedPageIndex, deletedPageCount);
  }

  /**
   * 根据appGridInfo刷新pages
   *
   * @param appGridInfo 用于swiper展示的列表数据
   */
  public refreshPages(appGridInfoLength: number): void {
    if (this.pages.length === appGridInfoLength) {
      return;
    }

    // 开机初始化的pages在这里处理
    if (this.pages.length < appGridInfoLength) {
      this.updatePageMaxValue();
      for (let i: number = this.pages.length; i < appGridInfoLength; i++) {
        this.pages.push(this.maxValue);
        this.maxValue++;
      }
    } else {
      for (let i = this.pages.length - 1; i >= appGridInfoLength; i--) {
        this.pages.pop();
      }
    }
  }

  /**
   * 清空pages变量的值
   */
  public clearSwiperPages(): void {
    this.pages = [];
  }

  public static getInstance(): SwiperLoadData {
    return SwiperLoadData.instance;
  }
}
