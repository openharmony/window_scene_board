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
import { NotificationType } from '@ohos/systemuicommon/Index';
import { ImageSnapshotService, ImmInvertColorMgr, WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { CardAnimType, ImmersiveConstants } from '../../common/ImmersiveConstants';
import { ImmersiveCardItem } from './ImmersiveCardItem';
import { immersiveVm } from '../../viewmodel/ImmersiveVm';
import { ImmersiveCardList, UiExtensionDataArr } from '../../viewmodel/viewdata/ImmersiveCardList';
import { ImmersiveAnimManager } from '../../viewmodel/viewanim/ImmersiveAnimManager';
import { ImmersiveAnimKey, ImmersiveAnimScene } from '../../common/anim/ImmersiveAnimConstants';
import { ImmersivePanelState } from '../../viewmodel/viewdata/ImmersivePanelState';
import {
  immersiveKgMgr,
  ImmersiveState,
} from '@ohos/systemuicommon/';
import { ImmersiveCardConst, ImmersiveCardNameParam } from '../../common/constants/ImmersiveCardConst';
import { ImmersiveCardVm } from '../../viewmodel/ImmersiveCardVm';
import { image } from '@kit.ImageKit';
import { SlWidgetId } from '@ohos/screenlockcommon';
import { ImmersiveNtfData } from '../../viewmodel/viewdata/ImmersiveNtfData';

const TAG = 'ImmersiveKeyguardCardComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

// 外屏大小
const OUTER_SIZE = '980px';

/**
 * 沉浸卡片根节点
 */
@Component
export struct ImmersiveKeyguardCardComponent {
  /**
   * 沉浸动效管理器
   */
  private animMgr: ImmersiveAnimManager = immersiveVm.getImmersiveAnimMgr();
  /**
   * 卡片VM
   */
  private cardVm: ImmersiveCardVm = immersiveVm.getImmersiveCardVm();
  /**
   * 通知列表动效状态
   */
  @State cardAnimState: WidgetAnimState = this.animMgr.getCardAnimState(ImmersiveAnimKey.IMMERSIVE_CARD_ROOT);
  @State cardToggleAnim: WidgetAnimState = this.animMgr.getCardAnimState(CardAnimType.CARD_TOGGLE_TYPE);
  /**
   * 是否折叠屏展开
   */
  @Prop isFoldFullDisplay: boolean = false;
  @Prop isSmallFoldOuterScreen: boolean = false;
  /**
   * 通知面板类型，默认下拉面板
   */
  @Provide notificationType: number = NotificationType.TYPE_PHONE_KEYGUARD;

  @State immersiveState: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState()
  @State cardData: ImmersiveCardList = this.cardVm.getShowList();
  /**
   * 沉浸面板状态
   */
  @State panelState: ImmersivePanelState = this.cardVm.getPanelState();
  /**
   * uiExtension组件缓存机制：用户操作沉浸卡片，组件首次加载显示的同时缓存数据，最多缓存用户最近操作的3条数据
   * 组件锁屏上树，解锁下树或退出沉浸态5分钟后释放内存
   */
  @State uiExtensionDataArr: UiExtensionDataArr = this.cardData.getUiExtensionDataArr();

  aboutToAppear(): void {
    // 加入离屏截图组件
    const createBuilder = (param: image.PixelMap): CustomBuilder => this.OuterImageSnapshot(param);
    const imgSnapshot = new ImageSnapshotService(createBuilder);
    imgSnapshot.setUiContext(this.getUIContext());
    ImmInvertColorMgr.getInstance().setAstcSnapshot(imgSnapshot);
  }

  aboutToDisappear(): void {
    // 清空离屏截图
    ImmInvertColorMgr.getInstance().setAstcSnapshot();
  }

  private getImmersiveCardTranslate(): TranslateOptions {
    if (this.cardAnimState?.isSceneAnimating()) {
      return {
        x: this.cardAnimState.getTranX() ?? 0,
      };
    }
    return {
      x: 0,
    };
  }

  /**
   * 小外屏图片离屏渲染截图
   *
   * @param img ASTC图
   */
  @Builder
  OuterImageSnapshot(img: image.PixelMap) {
    Image(img)
      .objectFit(ImageFit.Cover)
      .draggable(false)
      .width(OUTER_SIZE)
      .height(OUTER_SIZE)
      .syncLoad(true)
      .autoResize(false)
  }

  build() {
    Stack() {
      Stack({ alignContent: Alignment.Center }) {
        ForEach(this.uiExtensionDataArr, (uiExtensionData: ImmersiveNtfData) => {
          ImmersiveCardItem({
            mItemData: uiExtensionData,
            mCurShowData: this.cardData.showData,
            animItemData: this.cardData.animShowData,
            animState: this.cardAnimState,
            isFoldFullDisplay: this.isFoldFullDisplay,
            isSmallFoldOuterScreen: this.isSmallFoldOuterScreen
          })
        }, (data: ImmersiveNtfData) => data.hashCode)

        if (!this.isUIExtensionData()) {
          ImmersiveCardItem({
            mItemData: this.cardData.showData,
            mCurShowData: this.cardData.showData,
            animItemData: this.cardData.animShowData,
            animState: this.cardAnimState,
            isFoldFullDisplay: this.isFoldFullDisplay,
            isSmallFoldOuterScreen: this.isSmallFoldOuterScreen,
          })
        }

        if ((this.cardToggleAnim.isSceneAnimating(ImmersiveAnimScene.SCENE_CARD_TO_CAPSULE) ||
        this.cardAnimState.isSceneAnimating(ImmersiveAnimScene.SCENE_CARD_UPDATE)) && !this.isUIExtensionData()) {
          ImmersiveCardItem({
            mItemData: this.cardData.animShowData,
            mCurShowData: this.cardData.showData,
            animItemData: undefined,
            animState: this.cardToggleAnim.isSceneAnimating(ImmersiveAnimScene.SCENE_CARD_TO_CAPSULE) ?
            this.cardToggleAnim : this.animMgr.getCardAnimState(CardAnimType.CARD_UPDATE_TYPE),
            isAnimComponent: true,
            isFoldFullDisplay: this.isFoldFullDisplay,
            isSmallFoldOuterScreen: this.isSmallFoldOuterScreen,
            itemName: ImmersiveCardNameParam.ANIM_ITEM
          })
        }
        Stack().width('100%').height('100%')
          .id(SlWidgetId.IMMERSIVE_CARD_FOR_AOD)
          .hitTestBehavior(HitTestMode.None)
      }
      .id(SlWidgetId.IMMERSIVE_CARD_SHOW_AREA)
      .margin(this.isSmallFoldOuterScreen ? undefined : { top: this.panelState.marginTop })
      .padding(this.isSmallFoldOuterScreen ? undefined :
        { left: ImmersiveCardConst.CARD_LR_PADDING, right: ImmersiveCardConst.CARD_LR_PADDING })
      .width('100%')
      .height(this.isSmallFoldOuterScreen ? '100%' : `calc(100% - ${this.panelState.marginTop})`)
      .hitTestBehavior(HitTestMode.None)
      .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
        immersiveVm.getImmersiveMeshManager().onCardSizeChange(oldValue, newValue);
        this.cardVm.updateCardHeight(this.isFoldFullDisplay, newValue?.height as number);
      })
    }
    .width('100%')
    .height('100%')
    .padding(this.isSmallFoldOuterScreen ? undefined :
      { top: this.panelState.paddingTop, bottom: this.panelState.paddingBottom })
    .hitTestBehavior(HitTestMode.None)
    .translate(this.getImmersiveCardTranslate())
  }

  private isUIExtensionData(): boolean {
    return this.cardData.showData?.isUiExtensionCard() ?? false;
  }
}
