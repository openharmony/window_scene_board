/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { LogDomain, Logger, SingleBase } from '@ohos/basicutils';
import { LayoutViewModel } from '@ohos/launchercommon';
import { SCBRecentStyleManager } from './foldMachine/SCBRecentStyle';

const TAG = 'SCBRecentLayout';
const log = Logger.getLogHelper(LogDomain.RECENT);

/**
 * 任务中心布局
 * |------------------------------------------------------------------------------------------------|
 * |                |                                |                            |                 |
 * |                |                            marginTop                        |                 |
 * |                |                                |                            |                 |
 * | - marginLeft - |-------------------------------------------------------------| - marginRight - |
 * |                |  card area                     |                            |                 |
 * |                |                            paddingTop                       |       -----     |
 * |                |                                |                            |      |     |    |
 * |                |                     |--------------------|                  |      |     |    |
 * |                |                     |        card        |                  |      |     |    |
 * |                |                     |                    |                  |      |     |    |
 * |                |                     |--------------------|                  |      |     |    |
 * |                |                           cardMargin                        |      | bar |    |
 * |                |                     |--------------------|                  |      |     |    |
 * |                |                     |        card        |                  |      |     |    |
 * |                |                     |                    |                  |      |     |    |
 * |                |                     |--------------------|                  |      |     |    |
 * |                |                                |                            |      |     |    |
 * |                |                          paddingBottom                      |      |     |    |
 * |                |                                |                            |       -----     |
 * |                |-------------------------------------------------------------|                 |
 * |                |                                |                            |                 |
 * |                |                          marginBottom                       |                 |
 * |                |                                |                            |                 |
 * |------------------------------------------------------------------------------------------------|
 * |                                                 |                                              |
 * |                                               dock                                             |
 * |                                                 |                                              |
 * |------------------------------------------------------------------------------------------------|
 */
export class SCBRecentLayout {
  protected screenID: number;
  protected recentShowWidth: number = 0;
  protected recentShowHeight: number = 0;
  protected cardHeight: number = 0;
  protected cardMargin: number = 0;
  protected cardRowNum: number = 0;

  constructor(screenID: number) {
    this.screenID = screenID;
  }

  public updateRecentInfo(recentShowWidth: number, recentShowHeight: number): void {
    this.recentShowWidth = recentShowWidth;
    this.recentShowHeight = recentShowHeight;
    log.showInfo(TAG, `updateRecentInfo:${this.recentShowWidth}, ${this.recentShowHeight}`);
  }

  public updateCardInfo(cardHeight: number, cardMargin: number, cardRowNum: number): void {
    this.cardHeight = cardHeight;
    this.cardMargin = cardMargin;
    this.cardRowNum = cardRowNum;
    log.showInfo(TAG, `updateCardInfo:${cardHeight}, ${cardMargin}, ${cardRowNum}`);
  }

  /**
   * 卡片区域距离屏幕顶部高度
   * @returns
   */
  public getMarginTop(): number {
    return SCBRecentStyleManager.getInstance({ extendScreenId: this.screenID }).getStyle().cardsMarginTop;
  }

  protected getMarginBottom(): number {
    return this.getMarginTop();
  }

  /**
   * 当前所有卡片的高度，包括卡片行间距
   * @returns
   */
  protected getCardsHeight(): number {
    return (this.cardHeight + this.cardMargin) * this.cardRowNum - this.cardMargin;
  }

  /**
   * 卡片区域顶部距第一行卡片距离
   * @returns
   */
  public getPaddingTop(): number {
    const paddingHeight = this.getCardAreaHeight() - this.getCardsHeight();
    return paddingHeight > 0 ? paddingHeight / 2 : 0;
  }

  protected getSplitCardAreaHeight(): number {
    return this.recentShowHeight - this.getMarginTop() - this.getMarginBottom();
  }

  protected getCardAreaHeight(): number {
    if (SCBRecentStyleManager.getInstance({ extendScreenId: this.screenID }).getStyle().isSplitStyle) {
      return this.getSplitCardAreaHeight();
    }
    const dockHeight = LayoutViewModel.getInstance().getDockHeight();
    log.showInfo(TAG, `getCardAreaHeight:${this.recentShowHeight}, ${dockHeight}`);
    return this.recentShowHeight - dockHeight - this.getMarginTop() - this.getMarginBottom();
  }
}

/**
 * hopper任务中心布局
 * hpr任务中心差异点 不论卡片是否超B面高度，B面卡片在竖直方向居中显示
 * 竖屏 横屏 物理键盘 虚拟键盘态只存在B面，B面即任务中心区域
 * 悬停态存在C面，C面卡片竖直方向上顶部对齐，暂不在此处理
 */
export class SCBHprRecentLayout extends SCBRecentLayout {

  /**
   * 获取hpr各状态卡片区域高度
   * @returns
   */
  protected getCardAreaHeight(): number {
    return super.getCardAreaHeight();
  }

  /**
   * 获取hpr各状态内衬高度
   * hpr各状态 卡片都在卡片显示区域内居中显示，不区分卡片是否超过卡片显示区域
   * 卡片高度超卡片区域高度后，返回卡片区域承载最大的卡片时，卡片区域的内衬高度
   * @returns
   */
  public getPaddingTop(): number {
    return super.getPaddingTop();
  }

  /**
   * 获取最小内衬高度，即卡片区域最大程度容纳卡片时，卡片区域的内衬高度
   * @returns
   */
  private getMinPaddingTop(): number {
    let cardsHeight = 0;
    let minPaddingTop = 0;
    const cardAreaHeight = this.getCardAreaHeight();
    for (let i = 0; i < this.cardRowNum; i++) {
      cardsHeight += this.cardHeight;
      if (cardsHeight >= cardAreaHeight) {
        return minPaddingTop;
      }
      minPaddingTop = (cardAreaHeight - cardsHeight) / 2;
      cardsHeight += this.cardMargin;
    }
    return minPaddingTop;
  }
}