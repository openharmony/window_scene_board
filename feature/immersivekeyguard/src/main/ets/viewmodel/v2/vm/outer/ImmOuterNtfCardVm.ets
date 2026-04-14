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

import { image } from '@kit.ImageKit';
import { LogDomain, Logger } from '@ohos/basicutils';
import { ScreenLockApi } from '@ohos/screenlockcommon';
import {
  CmpPosWrapper,
  ComponentPosition,
  ImageSnapshotService,
  ImmInvertColorInfo,
  ImmInvertColorMgr,
  OnInvertColorChangeListener
} from '@ohos/screenlockcommon/Index';
import { ImmersiveType, ImmersiveTypeScene } from '@ohos/systemuicommon';
import { scbStatusBarStatusManager, StatusBarExternalVm } from '@ohos/systemuicommon/Index';
import { CardShowType, LiveCardHeight } from '../../../../common/constants/ImmCardConst';
import { ImmComAnimScene } from '../../../../common/constants/ImmComConst';
import { ImmersiveComHelper } from '../../../../common/helper/ImmersiveComHelper';
import { ImmCardData } from '../../../../model/data/v2/ImmCardData';
import { OuterCardVmStyleMgr } from '../../mgr/outer/OuterCardVmStyleMgr';
import { ImmersiveNtfCardVm } from '../ImmersiveNtfCardVm';

const TAG = 'ImmOuterNtfCardVm';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

/**
 * 小外屏沉浸大卡业务管理
 */
@ObservedV2
export class ImmOuterNtfCardVm extends ImmersiveNtfCardVm {
  // 实况卡片高度缓存，groupKey -> height
  private readonly liveCardHeight: Map<string, number> = new Map();

  /**
   * 状态栏反色信息切换回调
   */
  private onInvertColorChange: OnInvertColorChangeListener = {
    onInvertColorChange: (curInvertColor: ImmInvertColorInfo): void => {
      this.updateInvertColor(curInvertColor);
    },
  };

  /**
   * 离屏截图初始化
   *
   * @param ctx UI环境
   * @param imgBuilder Image组件
   */
  public initAstcSnapshot(ctx: UIContext, imgBuilder: (param: image.PixelMap) => CustomBuilder): void {
    const imgSnapshot = new ImageSnapshotService(imgBuilder);
    imgSnapshot.setUiContext(ctx);
    ImmInvertColorMgr.getInstance().setAstcSnapshot(imgSnapshot);
  }

  /**
   * 初始化
   */
  public init(): void {
    super.init();
    // 播控同步状态
    ImmersiveComHelper.setMediaLiveCardAnim();
    // 初始化时，已存在显示卡片，标识反色
    let curGroupKey = this.cardStyleMgr?.getCurImmCard();
    ImmInvertColorMgr.getInstance().setCurShowingImmersive(curGroupKey);
    // 注册反色回调
    ImmInvertColorMgr.getInstance().registerInvertListener(this.onInvertColorChange);
  }

  /**
   * 资源回收
   */
  public destroy(): void {
    super.destroy();
    // 实况卡片收拢状态复位
    this.cardStyleMgr?.resetLiveFoldSt();
    // 清空实况高度缓存
    this.liveCardHeight.clear();
    // 清空离屏截图
    ImmInvertColorMgr.getInstance().setAstcSnapshot();
    // 清空反色缓存
    ImmInvertColorMgr.getInstance().deleteAllCache();
    // 注销反色回调
    ImmInvertColorMgr.getInstance().unregisterInvertListener(this.onInvertColorChange);
  }

  /**
   * 沉浸大卡根布局位置缓存
   *
   * @param oldValue 旧区域
   * @param newValue 新区域
   */
  public onCardAreaChange(oldValue: Area, newValue: Area): void {
    super.onCardAreaChange(oldValue, newValue);
    // 同步计算实况卡片位置进行缓存(缺高度)
    this.updateLiveCardArea();
    // 分享实况卡片位置
    this.shareLiveCardPos();
  }

  /**
   * 实况卡片大小切换
   *
   * @param groupKey 分组标识
   * @param newValue 新大小
   */
  public onLiveCardSizeChange(groupKey: string, newValue: SizeOptions): void {
    // 实况卡片存在收拢/展开状态，需动态调整位置
    this.liveCardHeight.set(groupKey, (newValue?.height as number) ?? 0);
    // 分享实况卡片位置
    this.shareLiveCardPos();
  }

  /**
   * 取用实况卡片位置
   *
   * @param groupKey 卡片标识
   * @returns 卡片位置
   */
  public getLiveCardPos(groupKey?: string): ComponentPosition {
    // 使用卡片位置和高度进行拼接
    let livePos = CmpPosWrapper.wrapper(this.getLiveCardCache()?.getWidgetPosition());
    let liveHeight = this.getLiveCardHeight(groupKey);
    let realY = livePos.getCmpGlobalY() - liveHeight;
    return { globalX: livePos.getCmpGlobalX(), globalY: realY, width: livePos.getCmpWidth(), height: liveHeight };
  }

  /**
   * 取用实况卡片位置，考虑收拢/展开状态
   *
   * @param groupKey 卡片标识
   * @returns 卡片real位置
   */
  public getRealLiveCardPos(groupKey?: string): ComponentPosition {
    let livePos = this.getLiveCardPos(groupKey);
    // 卡片收拢状态时，Y值靠底
    let isLiveFold = this.getSlStaticState()?.isLiveCardFold() ?? false;
    if (isLiveFold) {
      livePos.globalY = (livePos.globalY ?? 0) + (livePos.height ?? 0);
    }
    return livePos;
  }

  /**
   * 实况列表测点击卡片位置
   *
   * @returns 点击卡片位置
   */
  public getClickLiveCardPos(): ComponentPosition {
    return ImmersiveComHelper.getShareLiveCardArea();
  }

  /**
   * 实况胶囊位置
   *
   * @returns 胶囊位置
   */
  public getLiveCapPos(): ComponentPosition {
    return ImmersiveComHelper.getLiveCapArea();
  }

  /**
   * 当前沉浸态卡片数据
   *
   * @param groupKey 分组标识
   */
  public setCurImmCardData(groupKey?: string): void {
    let oldData = this.getImmValidData(this.cardStyleMgr.getCurImmCard());
    super.setCurImmCardData(groupKey);
    let newData = this.getImmValidData(groupKey);
    // 沉浸态数据切换，发送事件
    if (oldData?.getGroupKey() !== groupKey) {
      // 旧数据退出沉浸态
      if (oldData) {
        ImmersiveComHelper.postExitImmEvent(oldData?.getHashcode());
      }
      // 新数据进入沉浸态
      if (groupKey) {
        ImmersiveComHelper.postEnterImmEvent(newData?.getHashcode());
      }
    }
    // 刷新当前沉浸态卡片
    ImmInvertColorMgr.getInstance().setCurShowingImmersive(groupKey);
  }

  /**
   * 复写返回按钮点击事件
   *
   * @param itemData 沉浸数据
   */
  public onBackBtnClick(itemData: ImmCardData): void {
    log.showInfo(TAG, `onBackBtnClick data: ${itemData?.getGroupKey()}`);
    this.onBackGestureEvent();
  }

  /**
   * 复写实况卡片顶部箭头点击事件
   */
  public onLiveArrowClick(): void {
    let isCurFold = this.getSlStaticState()?.isLiveCardFold() ?? false;
    log.showInfo(TAG, `onLiveArrowClick data: ${isCurFold}`);
    // 切换收拢/展开状态
    this.cardStyleMgr?.updateStaticLiveFoldSt(!isCurFold, true);
  }

  /**
   * 复写实况卡片下滑手势回调
   */
  public onLiveCardDownEvent(): void {
    log.showInfo(TAG, 'onLiveCardDownEvent');
    // 切换到收拢状态
    this.cardStyleMgr?.updateStaticLiveFoldSt(true, true);
  }

  /**
   * 退出沉浸态
   *
   * @param isToCap 是否过渡到胶囊
   * @param scene 退出场景
   * @returns true正常退出
   */
  public onExitImmState(isToCap?: boolean, scene?: ImmersiveTypeScene): boolean {
    // 除实况胶囊点击过渡实况列表场景，其他均从沉浸态过渡到胶囊态
    isToCap = scene !== ImmersiveTypeScene.SCENE_LIVE_CAP_LIST;
    let conData = this.getSlCardData()?.getCardData(CardShowType.CARD_CONTENT);
    if (!conData) {
      this.cardStyleMgr.setDefaultImmState();
      log.showWarn(TAG, `onExitImmState content data err: ${scene}`);
      return false;
    }
    if (isToCap) {
      // 记录胶囊大卡数据
      this.getCheckCardData()?.set(CardShowType.CARD_CAP, conData);
      // 播控保持不下树
      if (conData.isMediaCenter()) {
        this.getSlCardData()?.setCardData(CardShowType.CARD_CAP, conData);
      }
      this.cardStyleMgr.switchImmState(ImmersiveType.TYPE_CAPSULE, scene);
      this.getWholeAnimVm()?.startHybridAnim({
        animScene: ImmComAnimScene.ANIM_CARD_LIVE_CAP
      });
    } else {
      // 记录列表大卡数据
      this.getCheckCardData()?.set(CardShowType.CARD_LIST, conData);
      // 播控保持不下树
      if (conData.isMediaCenter()) {
        this.getSlCardData()?.setCardData(CardShowType.CARD_LIST, conData);
      }
      this.cardStyleMgr.switchImmState(ImmersiveType.TYPE_LIST, scene);
      this.getWholeAnimVm()?.startHybridAnim({
        animScene: ImmComAnimScene.ANIM_CARD_LIVE_LIST
      });
    }
    // 退出沉浸态，小外屏记忆能力置为默认非沉浸态
    this.cardStyleMgr.setOuterDefaultEnterImm(false);
    log.showInfo(TAG, `onExitImmState exit immersive state: ${isToCap}, ${scene}`);
    return true;
  }

  /**
   * 实况列表过渡沉浸态
   *
   * @param groupKey 分组标识
   * @param scene 进入沉浸态场景标识
   */
  public onLiveListToImmCard(groupKey: string, scene?: ImmersiveTypeScene): void {
    // 数据安全性检测
    let cardData = this.getImmValidData(groupKey);
    if (!cardData) {
      log.showWarn(TAG, `onLiveListToImmCard data err: ${groupKey}`);
      return;
    }
    // UIExtension数据，解锁安全校验，请求解锁
    if (cardData.isUiExtensionCard() && !this.cardStyleMgr.isOsAccountUnlocked()) {
      log.showWarn(TAG, `onLiveListToImmCard ui extension locked: ${groupKey}`);
      ScreenLockApi.requestUnlock();
      return;
    }
    // 实况列表过渡沉浸态，动效过渡
    this.cardStyleMgr.setCurImmData(groupKey);
    this.cardStyleMgr.switchImmState(ImmersiveType.TYPE_IMMERSIVE, scene);
    this.getWholeAnimVm()?.startHybridAnim({
      animScene: ImmComAnimScene.ANIM_LIVE_LIST_CARD
    });
    log.showWarn(TAG, `onLiveListToImmCard list to card: ${groupKey}`);
  }

  protected createStyleMgr(): OuterCardVmStyleMgr {
    return new OuterCardVmStyleMgr(this.vmInjector);
  }

  protected onImmDataDel(delData: ImmCardData): void {
    super.onImmDataDel(delData);
    // 清除壁纸反色
    ImmInvertColorMgr.getInstance().deleteCacheByHash(delData.getGroupKey());
    // 清除对应高度缓存
    this.liveCardHeight.delete(delData.getGroupKey());
  }

  protected onImmDataUpdate(updateData: ImmCardData): void {
    super.onImmDataUpdate(updateData);
    this.cacheInvertColor(updateData);
  }

  protected onImmDataAdd(addData: ImmCardData): void {
    super.onImmDataAdd(addData);
    this.cacheInvertColor(addData);
  }

  private cacheInvertColor(data: ImmCardData): void {
    // UIExtension开启状态栏渐变色
    let isUIExtension = data.isUiExtensionCard();
    ImmInvertColorMgr.getInstance().cacheSbBgGradientState(data.getGroupKey(), isUIExtension);
    // 大图取图反色
    if (!isUIExtension) {
      ImmInvertColorMgr.getInstance().cacheInvertColor(data.getGroupKey(), data.getBigPic());
    }
  }

  private updateInvertColor(curInvertColor: ImmInvertColorInfo): void {
    log.showInfo(TAG, `updateInvertColor: ${curInvertColor?.getSbContentColor()},
      ${curInvertColor?.isSbBgGradientEnable()}`);
    // 小折叠刷新状态栏反色
    scbStatusBarStatusManager.setImmersiveStatusbarColor(curInvertColor?.getSbContentColor());
    // 状态栏背景渐变色开关
    StatusBarExternalVm.instance.setIsShowGradientBackground(curInvertColor?.isSbBgGradientEnable());
  }

  private updateLiveCardArea(): void {
    // 实况卡片在布局底部，按高度0计算位置区域
    let rootPos = CmpPosWrapper.wrapper(this.getSlCacheState()?.getWidgetPosition());
    let liveStyle = this.getLiveCardStyle();
    let marginL = liveStyle?.getMarginL() ?? 0;
    let marginR = liveStyle?.getMarginR() ?? 0;
    let marginB = liveStyle?.getMarginB() ?? 0;
    let rootL = rootPos.getCmpGlobalX();
    let rootB = rootPos.getCmpGlobalY() + rootPos.getCmpHeight();
    let liveX = rootL + marginL;
    let liveWidth = rootPos.getCmpWidth() - (marginL + marginR);
    let liveY = rootB - marginB;
    let livePos: ComponentPosition = { globalX: liveX, globalY: liveY, width: liveWidth, height: 0 };
    this.getLiveCardCache()?.setWidgetPosition(livePos);
  }

  private getLiveCardHeight(groupKey?: string): number {
    // 优先使用缓存高度
    let cacheHeight = this.liveCardHeight.get(groupKey ?? '');
    if (cacheHeight) {
      return cacheHeight;
    }
    // 无缓存高度时，使用默认高度
    let isMedia = this.getImmValidData(groupKey)?.isMediaCenter() ?? false;
    return isMedia ? LiveCardHeight.MEDIA_HEIGHT : LiveCardHeight.DEFAULT_HEIGHT;
  }

  private shareLiveCardPos(): void {
    // 分享实况卡片位置，当前显示的实况卡片
    let curGroupKey = this.cardStyleMgr.getCurImmCard();
    let livePos = this.getLiveCardPos(curGroupKey);
    ImmersiveComHelper.shareLiveCardArea(livePos);
  }
}