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

import { SlWidgetZIndex, WAnimScene } from '@ohos/screenlockcommon';
import {
  ComponentPosition,
  WidgetAnimState,
  WidgetAnimStateV2,
  WidgetStyleStateV2
} from '@ohos/screenlockcommon/Index';
import { NotificationArray, NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { CapAnimSuffix, CapShowType } from '../../../../common/constants/ImmCapConst';
import { CardAnimSuffix, CardShowType } from '../../../../common/constants/ImmCardConst';
import { HybridAnimParam } from '../../../../common/constants/ImmComConst';
import { ListAnimSuffix } from '../../../../common/constants/ImmListConst';
import { IImmersiveCapAnimVm } from '../../../../common/interface/IImmersiveCapAnimVm';
import { IImmersiveCapVm } from '../../../../common/interface/IImmersiveCapVm';
import { IImmersiveCardAnimVm } from '../../../../common/interface/IImmersiveCardAnimVm';
import { IImmersiveCardVm } from '../../../../common/interface/IImmersiveCardVm';
import { IImmersiveListAnimVm } from '../../../../common/interface/IImmersiveListAnimVm';
import { IImmersiveListVm } from '../../../../common/interface/IImmersiveListVm';
import { IImmersiveNtfItemVm } from '../../../../common/interface/IImmersiveNtfItemVm';
import { IImmersiveNtfVmInjector } from '../../../../common/interface/IImmersiveNtfVmInjector';
import { IImmV1StateVm } from '../../../../common/interface/IImmV1StateVm';
import { ISlClockAnimVm } from '../../../../common/interface/ISlClockAnimVm';
import { ImmCapCfgKey } from '../../../../model/data/config/ImmCapCfgKey';
import { ImmCardCfgKey } from '../../../../model/data/config/ImmCardCfgKey';
import { ImmComAnimConfig } from '../../../../model/data/config/ImmComAnimConfig';
import { ImmComPtConfig } from '../../../../model/data/config/ImmComPtConfig';
import { ImmListCfgKey } from '../../../../model/data/config/ImmListCfgKey';
import { SlClockCfgKey } from '../../../../model/data/config/SlClockCfgKey';
import { ImmCapCheckData } from '../../../../model/data/v2/ImmCapCheckData';
import { ImmCapDataArray } from '../../../../model/data/v2/ImmCapDataArray';
import { ImmCardCheckData } from '../../../../model/data/v2/ImmCardCheckData';
import { ImmCardDataArray } from '../../../../model/data/v2/ImmCardDataArray';
import { SlListStaticStateV2 } from '../../../../model/data/v2/SlListStaticStateV2';
import { IChildHybridAnim } from './IChildHybridAnim';

/**
 * 联合动效子模块基类
 */
export abstract class ChildHybridBaseAnim implements IChildHybridAnim {
  // 通用注入器
  protected readonly vmInjector: IImmersiveNtfVmInjector;

  // 动效启动场景
  protected animStartScene?: WAnimScene;

  // 动效结束场景
  protected animFinishScene?: WAnimScene;

  // 动效中扩展参数
  protected extendAnimParam?: HybridAnimParam;

  // end alpha动效前缀
  protected cfgAlphaPrefix?: string;

  // end click回弹动效前缀
  protected cfgClickPrefix?: string;

  // end main动效前缀
  protected cfgMainPrefix?: string;

  constructor(vmInjector: IImmersiveNtfVmInjector) {
    this.vmInjector = vmInjector;
  }

  public buildInitCfg(initCfg: ImmComPtConfig, scene: WAnimScene): void {
    this.animStartScene = scene;
  }

  public buildFinishCfg(finishCfg: ImmComPtConfig, scene: WAnimScene): void {
    this.animFinishScene = scene;
  }

  public abstract buildEndCfg(endCfg: ImmComPtConfig): void;

  public abstract onHybridAnim(animCfg: ImmComAnimConfig): void;

  public setHybridAnimParam(param?: HybridAnimParam): void {
    this.extendAnimParam = param;
  }

  updateCfgAlphaPrefix(cfgName: string): void {
    this.cfgAlphaPrefix = cfgName;
  }

  updateCfgClickPrefix(cfgName: string): void {
    this.cfgClickPrefix = cfgName;
  }

  updateCfgMainPrefix(cfgName: string): void {
    this.cfgMainPrefix = cfgName;
  }

  protected getCardRaiseZIndex(): number {
    // 大卡层级高于胶囊、列表
    return SlWidgetZIndex.Z_INDEX_IMMERSIVE_CAP + 2;
  }

  protected getListRaiseZIndex(): number {
    // 列表层级高于胶囊
    return SlWidgetZIndex.Z_INDEX_IMMERSIVE_CAP + 1;
  }

  protected getListItemRaiseZIndex(): number {
    // 列表条目层级抬升
    return Number.MAX_VALUE;
  }

  protected getCapRootAnim(): WidgetAnimStateV2 | undefined {
    return this.getCapAnimVm()?.getRootAnimSt();
  }

  protected getCardRootAnim(): WidgetAnimStateV2 | undefined {
    return this.getCardAnimVm()?.getRootAnimSt();
  }

  protected getListRootAnim(): WidgetAnimStateV2 | undefined {
    return this.getListAnimVm()?.getRootAnimSt();
  }

  protected getCardV1RootAnim(): WidgetAnimState | undefined {
    return this.getImmV1StVm()?.getCardStaticStV1()?.getSlRootCardAnimCtrl();
  }

  protected getListV1RootAnim(): WidgetAnimState | undefined {
    return this.getImmV1StVm()?.getListStaticStV1()?.getSlRootListAnimCtrl();
  }

  protected getCapComAnim(capType: CapShowType): WidgetAnimStateV2 | undefined {
    return this.getCapAnimVm()?.getItemComAnimSt(capType);
  }

  protected getCardComAnim(cardType: CardShowType): WidgetAnimStateV2 | undefined {
    return this.getCardAnimVm()?.getItemComAnimSt(cardType);
  }

  protected getCardLiveAnim(cardType: CardShowType): WidgetAnimStateV2 | undefined {
    return this.getCardAnimVm()?.getLiveCardAnimSt(cardType);
  }

  protected getCardLiveV1Anim(): WidgetAnimState | undefined {
    return this.getCardAnimVm()?.getLiveCardAnimV1St();
  }

  protected getListComAnim(groupKey?: string): WidgetAnimStateV2 | undefined {
    return groupKey ? this.getListAnimVm()?.getItemComAnimSt(groupKey) : undefined;
  }

  protected getListFoldAnim(groupKey?: string): WidgetAnimStateV2 | undefined {
    return groupKey ? this.getListAnimVm()?.getItemFoldAnimSt(groupKey) : undefined;
  }

  protected getListShadowAnim(groupKey?: string): WidgetAnimStateV2 | undefined {
    return groupKey ? this.getListAnimVm()?.getItemShadowAnimSt(groupKey) : undefined;
  }

  protected getListInnerAnim(groupKey?: string): WidgetAnimStateV2 | undefined {
    return groupKey ? this.getListAnimVm()?.getItemInnerAnimSt(groupKey) : undefined;
  }

  protected getListBgAnim(groupKey?: string): WidgetAnimStateV2 | undefined {
    return groupKey ? this.getListAnimVm()?.getItemBgAnimSt(groupKey) : undefined;
  }

  protected getCapComStyle(capType: CapShowType): WidgetStyleStateV2 | undefined {
    return this.getCapAnimVm()?.getItemComStyle(capType);
  }

  protected getCardComStyle(cardType: CardShowType): WidgetStyleStateV2 | undefined {
    return this.getCardAnimVm()?.getItemComStyle(cardType);
  }

  protected getListComStyle(groupKey?: string): WidgetStyleStateV2 | undefined {
    return groupKey ? this.getListAnimVm()?.getItemComStyle(groupKey) : undefined;
  }

  protected getCapPos(capType: CapShowType): ComponentPosition | undefined {
    return this.getCapAnimVm()?.getValidItemPos(capType);
  }

  protected getCardPos(cardType: CardShowType): ComponentPosition | undefined {
    return this.getCardAnimVm()?.getItemComPos(cardType);
  }

  protected getImmLiveCardPos(groupKey?: string): ComponentPosition | undefined {
    return this.getCardAnimVm()?.getItemLivePos(groupKey);
  }

  protected getClickLivePos(): ComponentPosition | undefined {
    return this.getCardAnimVm()?.getClickLivePos();
  }

  protected getLiveCapPos(): ComponentPosition | undefined {
    return this.getCardAnimVm()?.getLiveCapPos();
  }

  protected getListPos(groupKey?: string): ComponentPosition | undefined {
    return groupKey ? this.getListAnimVm()?.getItemPos(groupKey) : undefined;
  }

  protected getCapRootKey(): ImmCapCfgKey {
    return ImmCapCfgKey.genKey();
  }

  protected getCardRootKey(): ImmCardCfgKey {
    return ImmCardCfgKey.genKey();
  }

  protected getListRootKey(): ImmListCfgKey {
    return ImmListCfgKey.genKey();
  }

  protected getCardV1RootKey(): ImmCardCfgKey {
    let animSt = this.getCardV1RootAnim();
    return ImmCardCfgKey.genV1Key(animSt?.getStateId());
  }

  protected getClockV1Key(): SlClockCfgKey {
    return SlClockCfgKey.genV1Key();
  }

  protected getListV1RootKey(): ImmListCfgKey {
    let animSt = this.getListV1RootAnim();
    return ImmListCfgKey.genV1Key(animSt?.getStateId());
  }

  protected getCapComKey(capType: CapShowType): ImmCapCfgKey {
    return ImmCapCfgKey.genKey(capType, CapAnimSuffix.ITEM_COMMON_ANIM);
  }

  protected getCardComKey(cardType: CardShowType): ImmCardCfgKey {
    return ImmCardCfgKey.genKey(cardType, CardAnimSuffix.ITEM_COMMON_ANIM);
  }

  protected getCardLiveKey(cardType: CardShowType): ImmCardCfgKey {
    return ImmCardCfgKey.genKey(cardType, CardAnimSuffix.LIVE_CARD_ANIM);
  }

  protected getCardLiveV1Key(): ImmCardCfgKey {
    let animSt = this.getCardLiveV1Anim();
    return ImmCardCfgKey.genV1Key(animSt?.getStateId());
  }

  protected getListComKey(groupKey?: string): ImmListCfgKey {
    return ImmListCfgKey.genKey(groupKey, ListAnimSuffix.ITEM_COMMON_ANIM);
  }

  protected getListInnerKey(groupKey?: string): ImmListCfgKey {
    return ImmListCfgKey.genKey(groupKey, ListAnimSuffix.ITEM_INNER_ANIM);
  }

  protected getListBgKey(groupKey?: string): ImmListCfgKey {
    return ImmListCfgKey.genKey(groupKey, ListAnimSuffix.ITEM_BG_ANIM);
  }

  protected getListShadowKey(groupKey?: string): ImmListCfgKey {
    return ImmListCfgKey.genKey(groupKey, ListAnimSuffix.ITEM_SHADOW_ANIM);
  }

  protected getCfgAlphaName(index?: number): string {
    // 非拼接场景
    if (index === undefined && this.cfgAlphaPrefix) {
      return this.cfgAlphaPrefix;
    }
    return `${this.cfgAlphaPrefix}_${index}`;
  }

  protected getCfgClickName(index?: number): string {
    // 非拼接场景
    if (index === undefined && this.cfgClickPrefix) {
      return this.cfgClickPrefix;
    }
    return `${this.cfgClickPrefix}_${index}`;
  }

  protected getCfgMainName(index?: number): string {
    // 非拼接场景
    if (index === undefined && this.cfgMainPrefix) {
      return this.cfgMainPrefix;
    }
    return `${this.cfgMainPrefix}_${index}`;
  }

  protected getCapData(): ImmCapDataArray | undefined {
    return this.getCapVm()?.getSlCapData();
  }

  protected getCardData(): ImmCardDataArray | undefined {
    return this.getCardVm()?.getSlCardData();
  }

  protected getListData(): NotificationArray | undefined {
    return this.getListVm()?.getSlNtfList();
  }

  protected getCheckCapData(): ImmCapCheckData | undefined {
    return this.getCapVm()?.getCheckCapData();
  }

  protected getCheckCardData(): ImmCardCheckData | undefined {
    return this.getCardVm()?.getCheckCardData();
  }

  protected getListStaticSt(): SlListStaticStateV2 | undefined {
    return this.getListVm()?.getSlStaticState();
  }

  protected getCapAnimVm(): IImmersiveCapAnimVm | undefined {
    return this.vmInjector?.getImmersiveCapAnimVm();
  }

  protected getCardAnimVm(): IImmersiveCardAnimVm | undefined {
    return this.vmInjector?.getImmersiveCardAnimVm();
  }

  protected getListAnimVm(): IImmersiveListAnimVm | undefined {
    return this.vmInjector?.getImmersiveListAnimVm();
  }

  protected getClockAnimVm(): ISlClockAnimVm | undefined {
    return this.vmInjector?.getSlClockAnimVm();
  }

  protected getCapVm(): IImmersiveCapVm | undefined {
    return this.vmInjector?.getImmersiveCapVm();
  }

  protected getCardVm(): IImmersiveCardVm | undefined {
    return this.vmInjector?.getImmersiveCardVm();
  }

  protected getListVm(): IImmersiveListVm | undefined {
    return this.vmInjector?.getImmersiveListVm();
  }

  protected getListItemVm(ntf?: NotificationBase): IImmersiveNtfItemVm | undefined {
    return ntf ? this.vmInjector?.getCardVm(ntf) : undefined;
  }

  protected getImmV1StVm(): IImmV1StateVm {
    return this.vmInjector?.getImmV1StateVm();
  }
}