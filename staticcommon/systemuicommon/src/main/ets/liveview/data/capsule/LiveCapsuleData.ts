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
import type image from '@ohos.multimedia.image';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { BaseExtendProperty } from '../../../base/common/info/BaseExtendProperty';
import type { ILiveExtendData } from '../../common/ILiveExtendData';
import type { IUpdatable } from '../../../base/common/interface/IUpdatable';
import { CapsuleRemindType, CapsuleShowType, CapsuleStatus, CapsuleType, SysTypeCode } from '../../common/LiveConstants';
import transResToPicHelper from '../../parse/utils/TransResToPicHelper';
import { ComponentAnimState } from '../../../base/anim/ComponentAnimState';
import { CapsuleAnimStyle } from '../../info/capsule/CapsuleAnimStyle';

const TAG = 'LiveCapsuleData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 胶囊卡片数据类型
 */
@Observed
export class LiveCapsuleData extends BaseExtendProperty implements IUpdatable {
  /**
   * 胶囊类型，默认文本类型
   */
  type: CapsuleType = CapsuleType.TYPE_TEXT;

  /**
   * 系统实况类型码，标识系统对应应用
   */
  typeCode?: SysTypeCode;

  /**
   * 胶囊显示类型，默认不显示
   */
  showType: CapsuleShowType = CapsuleShowType.NONE;

  /**
   * 胶囊状态，默认显示
   */
  status: CapsuleStatus = CapsuleStatus.STATUS_UPDATE;

  /**
   * 应用包名
   */
  bundleName: string;

  /**
   * 应用uid
   */
  public uid: number;

  /**
   * 通知唯一标示
   */
  public hashCode: string;

  /**
   * 应用在前台时是否展示胶囊，默认false，仅系统应用可为true
   */
  capsuleSticky: boolean = false;

  /**
   * session移除时，是否去掉胶囊数据，callUI定制化
   */
  capsuleHidden: boolean = false;

  /**
   * 胶囊阴影是否使用红色
   */
  isRedShadow: boolean = false;

  /**
   * 胶囊标题文本，文本类型时生效
   */
  title?: string;

  /**
   * 胶囊扩展文本，胶囊扩展态可用
   * TODO ANS待补充
   */
  extend?: string;

  /**
   * 胶囊提醒方式
   */
  isRemind: CapsuleRemindType = CapsuleRemindType.DEFAULT;

  /**
   * 胶囊图标
   */
  icon?: image.PixelMap | string;

  /**
   * 胶囊图标资源路径
   */
  iconResource: string;

  /**
   * 胶囊背景颜色
   */
  backgroundColor?: string;

  /**
   * 是否展示胶囊副文本区域
   */
  isContentDisplayed?: boolean = true;

  /**
   * 胶囊类型扩展数据
   * 计时器、进度类型时存在扩展数据
   */
  typeData?: ILiveExtendData;

  /**
   * 胶囊更新时旧图标，用于图标更新的转场动效
   */
  public prevIcon?: image.PixelMap | string;

  /**
   * 胶囊动效
   */
  public animState = new ComponentAnimState(TAG);

  /**
   * 胶囊特殊样式
   */
  public animStyle = new CapsuleAnimStyle();

  private isTypeDataTypeChanged(oldData: LiveCapsuleData, newData: LiveCapsuleData): boolean {
    return oldData?.type !== newData?.type;
  }

  /**
   * 复写接口ILiveUpdatable
   *
   * @param other 更新源数据
   * @param forceRefresh 是否强制刷新
   */
  update(other: object, forceRefresh?: boolean): void {
    if (!(other instanceof LiveCapsuleData)) {
      return;
    }
    let otherCapsule = other as LiveCapsuleData;

    // 扩展数据，强制更新或未设置或扩展数据类型切换，则直接设置
    if (forceRefresh || CommonUtils.isInvalid(this.typeData) || this.isTypeDataTypeChanged(this, otherCapsule)) {
      this.setCapsuleTypeData(otherCapsule.typeData, forceRefresh);
    } else {
      this.typeData?.update(otherCapsule.typeData, forceRefresh);
    }

    this.setCapsuleType(otherCapsule.type);
    this.setCapsuleTypeCode(otherCapsule.typeCode);
    this.setCapsuleStatus(otherCapsule.status);
    this.setBundleName(otherCapsule.bundleName);
    this.setCapsuleSticky(otherCapsule.capsuleSticky);
    this.setCapsuleHidden(otherCapsule.capsuleHidden);
    this.setUid(otherCapsule.uid);
    this.setCapsuleTitle(otherCapsule.title, forceRefresh);
    this.setCapsuleExtend(otherCapsule.extend, forceRefresh);
    this.setCapsuleRemind(otherCapsule.isRemind, forceRefresh);
    this.setCapsuleIcon(otherCapsule.icon, forceRefresh);
    this.setCapsuleIconResource(otherCapsule.iconResource, forceRefresh);
    this.setBackgroundColor(otherCapsule.backgroundColor, forceRefresh);
    this.setIsContentDisplayed(otherCapsule.isContentDisplayed, forceRefresh);
  }

  /**
   * 设置胶囊类型
   *
   * @param type 胶囊类型
   */
  setCapsuleType(type: CapsuleType): void {
    this.type = type;
  }

  /**
   * 设置胶囊类型
   *
   * @param type 胶囊类型
   */
  setCapsuleTypeCode(typeCode?: SysTypeCode): void {
    this.typeCode = typeCode;
  }

  /**
   * 设置胶囊状态
   *
   * @param status 胶囊状态
   */
  setCapsuleStatus(status: CapsuleStatus): void {
    this.status = status;
  }

  /**
   * 设置应用包名
   *
   * @param bundleName 应用包名
   */
  setBundleName(bundleName: string): void {
    this.bundleName = bundleName;
  }

  /**
   * 设置uid
   *
   * @param uid 应用uid
   */
  public setUid(uid: number): void {
    this.uid = uid;
  }


  /**
   * 设置通知唯一标识
   *
   * @param hashCode 通知唯一标识
   */
  public setHashCode(hashCode: string): void {
    this.hashCode = hashCode;
  }

  /**
   * 设置应用在前台时是否展示胶囊
   *
   * @param capsuleSticky true 展示 false 不展示
   */
  public setCapsuleSticky(capsuleSticky: boolean): void {
    this.capsuleSticky = capsuleSticky;
  }

  /**
   * 设置session销毁时是否移除胶囊
   *
   * @param capsuleHidden true 移除胶囊 false 不移除胶囊
   */
  public setCapsuleHidden(capsuleHidden: boolean): void {
    this.capsuleHidden = capsuleHidden;
  }

  /**
   * 胶囊是否移除
   *
   * @returns true移除
   */
  isCapsuleFinish(): boolean {
    return this.status === CapsuleStatus.STATUS_FINISH;
  }

  /**
   * 是否为胶囊强提醒更新
   *
   * @returns true胶囊强提醒更新
   */
  isFlipRemind(): boolean {
    return this.isRemind === CapsuleRemindType.FLIP;
  }

  /**
   * 是否为横幅提醒
   *
   * @returns true横幅提醒
   */
  isExpandRemind(): boolean {
    return this.isRemind === CapsuleRemindType.EXPAND;
  }


  /**
   * 设置胶囊标题
   *
   * @param title 标题
   * @param forceRefresh 是否强制刷新
   */
  setCapsuleTitle(title?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(title)) {
      this.title = title;
    }
  }

  /**
   * 设置胶囊扩展文本
   *
   * @param extend 扩展文本
   * @param forceRefresh 是否强制刷新
   */
  setCapsuleExtend(extend?: string, forceRefresh?: boolean): void {
    // 进度模板不展示扩展文本
    if (this.type === CapsuleType.TYPE_PROGRESS) {
      this.extend = null;
    } else if (forceRefresh || !CommonUtils.isInvalid(extend)) {
      this.extend = extend;
    }
  }

  /**
   * 设置强提醒
   *
   * @param remind true强提醒
   * @param forceRefresh 是否强制刷新
   */
  setCapsuleRemind(remind?: CapsuleRemindType, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(remind)) {
      this.isRemind = remind ?? CapsuleRemindType.DEFAULT;
    }
  }

  /**
   * 设置胶囊图标
   *
   * @param icon 胶囊图标
   * @param forceRefresh 是否强制刷新
   */
  setCapsuleIcon(icon?: image.PixelMap | string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(icon)) {
      this.icon = icon;
    }
  }

  /**
   * 设置胶囊图标
   *
   * @param icon 胶囊图标
   * @param forceRefresh 是否强制刷新
   */
  setCapsuleIconResource(iconResource?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(iconResource)) {
      this.iconResource = iconResource;
    }
  }

  /**
   * 设置胶囊临时动效图标
   *
   * @param forceRefresh 是否强制刷新
   */
  public setCapsulePrevIcon(forceRefresh?: boolean): void {
    const icon = this.icon;
    if (forceRefresh || !CommonUtils.isInvalid(icon)) {
      this.prevIcon = icon;
    }
  }

  /**
   * 释放 preIcon
   *
   */
  public releasePrevIcon(): void {
    if (typeof this.prevIcon === 'string') {
      this.prevIcon = undefined;
      return;
    }
    this.prevIcon?.release();
  }

  /**
   * 设置胶囊背景颜色
   *
   * @param backgroundColor 背景颜色
   * @param forceRefresh 是否强制刷新
   */
  setBackgroundColor(backgroundColor?: string, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(backgroundColor)) {
      this.backgroundColor = backgroundColor;
    }
  }

  /**
   * 设置是否展示胶囊副文本区域
   *
   * @param isContentDisplayed 是否展示胶囊副文本区域
   * @param forceRefresh 是否强制刷新
   */
  setIsContentDisplayed(isContentDisplayed?: boolean, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(isContentDisplayed)) {
      this.isContentDisplayed = isContentDisplayed;
    }
  }

  /**
   * 设置胶囊类型扩展数据
   *
   * @param typeData 扩展数据
   * @param forceRefresh 是否强制刷新
   */
  setCapsuleTypeData(typeData?: ILiveExtendData, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(typeData)) {
      this.typeData = typeData;
    }
  }

  /**
   * 获取胶囊类型扩展数据
   *
   * @returns 扩展数据
   */
  getCapsuleTypeData(): ILiveExtendData | undefined {
    if (CommonUtils.isInvalid(this.typeData)) {
      return this.typeData;
    }

    // 类型不匹配
    if (this.type?.valueOf() !== this.typeData.getLiveExtendType()?.valueOf()) {
      return undefined;
    }
    return this.typeData;
  }

  /**
   * 胶囊是否显示内容
   *
   * @returns true显示内容
   */
  isCapsuleShowContent(): boolean {
    return this.showType === CapsuleShowType.SHOW || this.showType === CapsuleShowType.TOP;
  }

  /**
   * 胶囊是否显示阴影
   *
   * @returns true显示阴影
   */
  isCapsuleShowShadow(): boolean {
    return this.showType === CapsuleShowType.SHADOW;
  }

  /**
   * 是否为目标数据类型
   *
   * @param type 类型
   * @returns true目标类型
   */
  isDataType(type: CapsuleType): boolean {
    return this.type === type;
  }

  /**
   * 释放PixelMap对象
   */
  releaseImages(): void {
    if (this.iconResource && typeof this.icon !== 'string') {
      log.showInfo('release capsule icon');
      this.icon?.release();
    }
  }

  toString(): string {
    return 'LiveCapsuleData:{type:' + this.type +
      ', status:' + this.status +
      ', bundleName:' + this.bundleName +
      ', isRemind:' + this.isRemind +
      ', backgroundColor:' + this.backgroundColor +
      ', isContentDisplayed:' + this.isContentDisplayed +
      '}';
  }
}