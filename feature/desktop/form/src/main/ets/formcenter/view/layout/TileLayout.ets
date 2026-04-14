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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CardItemInfo, CommonConstants, GridLayoutUtil } from '@ohos/launchercommon';
import { launcherStatusUtil } from '@ohos/windowscene';
import { NavDestinationViewData, RecommendFormItemData } from '../../../default/viewmodel/FormCenterObservedData';
import { FormCenterViewModel } from '../../viewmodel/FormCenterViewModel';
import { FormCenterViewData } from '../../../default/viewmodel/FormCenterViewData';
import FormStyleConstants from '../../../default/common/constants/FormStyleConstants';
import GridRowManager from '../../../default/manager/GridRowManager';
import { FormCenterFormItem } from '../atomicview/formitem/FormCenterFormItem';
import { FormItemEventInterface } from '../../interfaces/FormItemEventInterface';
import FormDescription from '../atomicview/FormDescription';
import { TileFormDescriptionFactory } from '../../viewmodel/factory/FormDescriptionFactory';
import { FormItemFactory } from '../../viewmodel/factory/FormItemFactory';
import { FormItemEventFactory } from '../../viewmodel/factory/FormItemEventFactory';
import { TileLayoutStyle } from '../../viewstyles/TileLayoutStyle';
import { FormStyleConfig } from '../../../default/common/FormStyleConfig';

const TAG = 'TileLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
const SCREEN_LOCK_COLUMN: number = 4;

@Component
export default struct TileLayout {
  public mFormList: CardItemInfo[] = [];
  public style: TileLayoutStyle = new TileLayoutStyle();
  private mGridRowManager: GridRowManager = FormCenterViewData.getInstance().getViewGridRowManager();
  @ObjectLink mViewData: NavDestinationViewData;

  aboutToAppear(): void {
    log.showInfo('FormTileLayoutStyle aboutToAppear');
    if (!this.mViewData) {
      log.showWarn('FormTileLayoutStyle params empty');
      return;
    }
  }

  private getFormItemEvent(index: number): FormItemEventInterface {
    let event: FormItemEventInterface = FormItemEventFactory.createFormItemEvent({
      formItem: this.mFormList[index],
      viewData: this.mViewData,
      index: index,
    });
    return event;
  }

  private card2x2InColumn(formItem: CardItemInfo, index: number): boolean {
    if (launcherStatusUtil.getShowOutLauncherStatus() ||
      formItem.cardDimension !== CommonConstants.CARD_DIMENSION_2x2 || index < 1 ||
      this.mFormList.length === index + 1) {
      return false;
    }
    // 前一张卡片是4*4 && 当前卡片是2*2 && 下一张卡片是2*2
    if (this.mFormList[index - 1].cardDimension === CommonConstants.CARD_DIMENSION_4x4 &&
      this.mFormList[this.mFormList.length - 1].cardDimension === CommonConstants.CARD_DIMENSION_2x2) {
      return true;
    }
    return false;
  }

  private showCard(formItem: CardItemInfo, index: number): boolean {
    let card4x4: CardItemInfo | undefined =
      this.mFormList.find(i => i.cardDimension === CommonConstants.CARD_DIMENSION_4x4);
    if (launcherStatusUtil.getShowOutLauncherStatus() || !card4x4 ||
      formItem.cardDimension !== CommonConstants.CARD_DIMENSION_2x2 || index < 2) {
      return true;
    }
    // 有4*4卡片&&当前卡片是最后一张2*2&&前一张卡片是2*2
    if (index === this.mFormList.length - 1 &&
      this.mFormList[index - 1].cardDimension === CommonConstants.CARD_DIMENSION_2x2) {
      return false;
    }
    return true;
  }

  @Builder
  TileItem(index: number, showMargin?: boolean) {
    Column() {
      FormCenterFormItem({
        formItem: this.mFormList[index],
        mEvent: this.getFormItemEvent(index),
        idIndex: index,
        formRate: this.mViewData.formRate,
        style: this.style.formItemStyle,
        formDescriptionEvent: TileFormDescriptionFactory.createFormItemEvent({
          formItem: this.mFormList[index],
        }),
        buildInterface: FormItemFactory.createFormItem({
          formItem: this.mFormList[index],
        }),
      })

      FormDescription({
        formItem: this.mFormList[index],
        style: this.style.formNameStyle,
        index: index,
        formDescriptionEvent: TileFormDescriptionFactory.createFormItemEvent({
          formItem: this.mFormList[index],
        }),
      })
    }
    .margin({bottom: showMargin ? FormStyleConstants.DEFAULT_FORM_MARGIN : 0})
  }

  build() {
    GridRow({
      columns: FormCenterViewModel.getInstance().isScreenLock ? SCREEN_LOCK_COLUMN : this.mGridRowManager.getColumns(),
      gutter: {
        x: this.mGridRowManager.getGutterX(),
        y: FormStyleConstants.DEFAULT_FORM_MARGIN
      }
    }) {
      ForEach(this.mFormList, (formItem: CardItemInfo, index: number) => {
        GridCol({ span: FormCenterViewModel.getInstance().getCardSpan(this.mFormList[index].cardDimension) }) {
          if (this.card2x2InColumn(formItem, index)) {
            Column() {
              this.TileItem(index, true)
              this.TileItem(this.mFormList.length - 1)
            }
          } else if (this.showCard(formItem, index)) {
            this.TileItem(index)
          }
        }
      }, (item: RecommendFormItemData, index: number): string => {
        return `${this.mFormList.length}${index}${this.mViewData.formRate}`;
      })
    }
    .margin({ left: this.mViewData.cardViewMargin, right: this.mViewData.cardViewMargin })
    .padding(this.style.gridRowPadding)
    .width(this.mViewData.viewWidth - this.mViewData.cardViewMargin * 2)
  }
}