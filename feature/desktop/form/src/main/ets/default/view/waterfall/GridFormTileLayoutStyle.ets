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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { AppModel, CardItemInfo } from '@ohos/launchercommon';
import { NavDestinationViewData, RecommendFormItemData } from '../../viewmodel/FormCenterObservedData';
import { GridStyleFormItem } from './GridStyleFormItem';
import { FormStyleConfig } from '../../common/FormStyleConfig';
import StyleManager from '../../manager/StyleManager';
import lazy PcFormStyleConstants from '../../common/constants/PcFormStyleConstants';
import { RecommendFormsViewEvent } from '../../viewmodel/RecommendFormsViewEvent';
import { SearchStateMgr } from '../../../formcenter/view/atomicview/SearchComponent';

const TAG = 'GridFormTileLayoutStyle';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export default struct GridFormTileLayoutStyle {
  private mEvent: RecommendFormsViewEvent = new RecommendFormsViewEvent();
  private gridOptions?: GridLayoutOptions;
  private isCardExceedLimit: boolean = false;
  private mFormList: CardItemInfo[] = [];
  private gridItemWidth: number = 0;
  @State mAnimateData: RecommendFormItemData[] = [];
  @State mViewData: NavDestinationViewData = new NavDestinationViewData();
  @State searchState: SearchStateMgr = SearchStateMgr.getInstance();

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.mEvent.initData(this.mFormList, this.mAnimateData, this.mViewData);
    if (this.mFormList.length !== this.mAnimateData.length) {
      log.showWarn('this.mFormList.length !== this.mAnimateData.length');
      return;
    }
    this.sortCardList(this.mFormList);
    this.gridOptions = this.getGridLayoutOptions(this.mFormList);
    this.updateData();
  }

  private getGridLayoutOptions(cardListInfo: CardItemInfo[]): GridLayoutOptions {
    if (CheckEmptyUtils.isEmptyArr(cardListInfo)) {
      return { regularSize: [1, 1] };
    }
    const indices: number[] = [];
    for (let index = 0; index < cardListInfo.length; index++) {
      indices.push(index);
    }
    return {
      regularSize: [1, 1],
      irregularIndexes: indices,
      onGetIrregularSizeByIndex: (index: number) => {
        if (index < 0 || index >= cardListInfo.length) {
          log.showWarn(`out of bounds, ${index}, ${cardListInfo.length}`);
          return [1, 1];
        }
        let filteredList: CardItemInfo[] = cardListInfo.filter((item: CardItemInfo) => this.isFormShow(item));
        const area: number[] | undefined = filteredList[index]?.area;
        if (!area || area.length < 2) {
          return [1, 1];
        }
        return [
          Math.ceil(area[1] / 2),
          Math.ceil(area[0] / 2)
        ];
      }
    };
  }

  private updateData(): void {
    this.mViewData.column = PcFormStyleConstants.PC_GRID_COLUMN_CNT;
    this.mViewData.viewWidth =
      (StyleManager.getSheetFormStyle()?.sheetWidth ?? PcFormStyleConstants.PC_DEFAULT_SHEET_WIDTH) -
      PcFormStyleConstants.APP_LIST_WIDTH;
    this.mViewData.cardViewMargin = PcFormStyleConstants.PC_GRID_VIEW_MARGIN;
    this.gridItemWidth =
      (this.mViewData.viewWidth - this.mViewData.cardViewMargin * 2 -
        PcFormStyleConstants.PC_GRID_COLUMN_GAP * 3) / this.mViewData.column;
    this.mViewData.formRate = this.gridItemWidth / FormStyleConfig.getInstance().getSizeX2();
    log.showInfo(`updateData ${this.mViewData.viewWidth} ${this.gridItemWidth} ${this.mViewData.formRate}`);
  }

  private sortCardList(formList: CardItemInfo[]): void {
    const validItems: CardItemInfo[] = formList.filter(item =>
      item.area && item.area.length === 2 && item.area[0] > 0 && item.area[1] > 0
    );

    validItems.sort((a, b) => {
      const areaA = (a.area && a.area.length === 2) ? (a.area[0] * a.area[1]) : 0;
      const areaB = (b.area && b.area.length === 2) ? (b.area[0] * b.area[1]) : 0;
      return areaB - areaA;
    });
    this.mFormList = validItems;
  }



  private getFormWidth(card: CardItemInfo): number {
    if (!card.area) {
      return 0;
    }
    let cardSpan: number = card.area[0] / 2;
    return this.gridItemWidth * cardSpan + (cardSpan - 1) * PcFormStyleConstants.PC_GRID_COLUMN_GAP;
  }

  private getFormHeight(card: CardItemInfo): number {
    if (!card.area) {
      return 0;
    }
    const cardSpan: number = card.area[1] / 2;
    //1*2卡片，卡片高度
    if (cardSpan < 1) {
      return 36;
    }
    return this.gridItemWidth * cardSpan + (cardSpan - 1) * PcFormStyleConstants.PC_GRID_COLUMN_GAP;
  }

  private getGridItemHeight(card: CardItemInfo): number {
    if (!card.area) {
      return 0;
    }
    const cardSpan: number = Math.ceil(card.area[1] / 2);
    const gridItemHeight: number = (this.gridItemWidth + PcFormStyleConstants.PC_GRID_COLUMN_GAP) * cardSpan;
    return gridItemHeight;
  }

  private getGridItemFormHeight(card: CardItemInfo): number {
    if (!card.area) {
      return 0;
    }
    const cardSpan: number = Math.ceil(card.area[1] / 2);
    const gridItemHeight: number =
      this.gridItemWidth * cardSpan + (cardSpan - 1) * PcFormStyleConstants.PC_GRID_COLUMN_GAP;
    return gridItemHeight;
  }

  private isFormShow(item: CardItemInfo): boolean {
    if (!this.searchState.getIsShowSearchResult() || !this.searchState.parsedSearchResult.get(item.bundleName)) {
      return true;
    }

    let descriptionMap: Map<string, string> =
      this.searchState.parsedSearchResult.get(item.bundleName)?.descriptionMap ?? new Map();
    if (descriptionMap.size <= 0) {
      return true;
    }

    return !!descriptionMap.get(item.cardName);
  }

  build() {
    Grid(undefined, this.gridOptions) {
      ForEach(this.mFormList, (item: CardItemInfo, index: number) => {
        if (this.isFormShow(item)) {
          GridItem() {
            GridStyleFormItem({
              mEvent: this.mEvent,
              formItem: item,
              formWidth: this.getFormWidth(item) / this.mViewData.formRate,
              formHeight: this.getFormHeight(item) / this.mViewData.formRate,
              gridHeight: this.getGridItemFormHeight(item),
              idIndex: index,
              formRate: this.mViewData.formRate,
              isCardExceedLimit: this.isCardExceedLimit,
              refreshFlag: this.searchState.refreshFlag,
            })
          }
          .height(this.getGridItemHeight(item))
        }
      }, (item: RecommendFormItemData, index: number): string => {
        return `${this.mFormList.length}${index}${this.mViewData.formRate}`;
      })
    }
    .scrollBar(BarState.Auto)
    .edgeEffect(EdgeEffect.Spring)
    .columnsGap(PcFormStyleConstants.PC_GRID_COLUMN_GAP)
    .id('Grid_Style_From_Center')
    .columnsTemplate('1fr 1fr 1fr 1fr')
    .padding({
      top: StyleManager.getSheetFormStyle()?.contentAreaMarginTop,
      left: this.mViewData.cardViewMargin,
      right: this.mViewData.cardViewMargin
    })
    .width(this.mViewData.viewWidth)
  }
}