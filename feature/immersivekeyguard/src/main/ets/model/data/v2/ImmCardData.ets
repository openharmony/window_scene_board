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

import { image } from '@kit.ImageKit';
import { ArrayUtils, CommonUtils, LogDomain, Logger } from '@ohos/basicutils';
import { LiveNotification } from '@ohos/systemuicommon/newIndex';
import { NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { CardShowType, LocationErrorCode, ALL_LOCATION_ERR,
  VALID_LOCATION_ERR, SettingsInfo, LocationPermission } from '../../../common/constants/ImmCardConst';
import { ImmersiveComHelper } from '../../../common/helper/ImmersiveComHelper';
import { ImmDataType } from '../../../common/ImmersiveConstants';
import { ImmBaseData } from './ImmBaseData';

const TAG = 'ImmCardData';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

// uiExtension loading时长
const MAX_LOADING_TIME_MS: number = 500;

/**
 * 沉浸大卡数据结构
 */
@ObservedV2
export class ImmCardData extends ImmBaseData<ImmCardData> {
  // 沉浸大卡显示类型
  @Trace private _cardShowType: CardShowType = CardShowType.CARD_NONE;

  // 沉浸大图
  @Trace private _immBigPic?: image.PixelMap;

  // UIExtension加载want
  @Trace private _immWant?: Want;

  // UIExtension是否允许交互
  @Trace private _isInteraction?: boolean;

  // 沉浸UI扩展标题，情景模式场景
  @Trace private _immExtTitle?: string;

  // 沉浸UI扩展副文本，情景模式场景
  @Trace private _immExtContent?: string;

  // UIExtension定位权限错误码
  @Trace private _locationErrCode: LocationErrorCode = LocationErrorCode.DEFAULT_CODE;

  // 沉浸态是否开启常亮
  @Trace private _isKeepScreenOnEnable?: boolean;

  // UIExtension是否loading
  @Trace private _isExtLoading?: boolean;

  // 沉浸卡片loading加载定时器
  @Trace private _loadingTimer?: number;

  /**
   * 属性还原
   */
  protected resetProperty(): void {
    super.resetProperty();
    this._immBigPic = undefined;
    this._immWant = undefined;
    this._isInteraction = undefined;
    this._immExtTitle = undefined;
    this._immExtContent = undefined;
    this._isKeepScreenOnEnable = undefined;
  }

  /**
   * 数据刷新
   *
   * @param update 原数据
   */
  public updateData(update: NotificationBase): void {
    super.updateData(update);
    if (update.isLiveView() && update.card) {
      let liveCard = update.card;
      this._immBigPic = liveCard.immersivePic;
      this._immWant = liveCard.immersiveWant;
      this._isInteraction = liveCard.isImmersiveInteraction;
      this._isKeepScreenOnEnable = liveCard.isKeepScreenOnEnable;
      let title = this._immWant?.parameters?.immersiveTitle;
      let content = this._immWant?.parameters?.immersiveContent;
      this._immExtTitle = CommonUtils.isString(title) ? title as string : undefined;
      this._immExtContent = CommonUtils.isString(content) ? content as string : undefined;
    }
  }

  /**
   * 标示大卡类型
   *
   * @returns 大卡类型
   */
  protected getImmDataType(): ImmDataType {
    return ImmDataType.DATA_CARD;
  }

  /**
   * 新实例
   *
   * @returns 新实例
   */
  protected createNewData(): ImmCardData {
    return new ImmCardData(this._oriData);
  }

  /**
   * 取值原通知数据
   *
   * @returns 原数据
   */
  public getOriData(): LiveNotification {
    return this._oriData as LiveNotification;
  }

  /**
   * 是否为UIExtension类型大卡
   *
   * @returns true UIExtension类型
   */
  public isUiExtensionCard(): boolean {
    return Boolean(this._immWant);
  }

  /**
   * 取值沉浸大图
   *
   * @returns 沉浸大图
   */
  public getBigPic(): image.PixelMap | undefined {
    return this._immBigPic;
  }

  /**
   * 取值UIExtension的want
   *
   * @returns want
   */
  public getUIWant(): Want | undefined {
    return this._immWant;
  }

  /**
   * UIExtension是否允许交互
   *
   * @returns true允许交互
   */
  public isInteraction(): boolean {
    return this._isInteraction ?? false;
  }

  /**
   * 扩展标题
   *
   * @returns 扩展标题
   */
  public getExtTitle(): string | undefined {
    return this._immExtTitle;
  }

  /**
   * 扩展副文本
   *
   * @returns 扩展副文本
   */
  public getExtContent(): string | undefined {
    return this._immExtContent;
  }

  /**
   * 设置大卡显示类型
   *
   * @param showType 大卡类型
   */
  public setCardShowType(showType: CardShowType): void {
    this._cardShowType = showType;
  }

  /**
   * 取用大卡显示类型
   *
   * @returns 大卡类型
   */
  public getCardShowType(): CardShowType {
    return this._cardShowType;
  }

  /**
   * 设置UIExtension定位权限错误码
   *
   * @param errCode 错误码
   */
  public setLocationErrCode(errCode: number): void {
    if (ArrayUtils.contains(ALL_LOCATION_ERR, errCode)) {
      this._locationErrCode = errCode;
    }
  }

  /**
   * 是否显示UIExtension定位权限缺失UI
   *
   * @returns true显示定位权限缺失UI
   */
  public isShowLocationErr(): boolean {
    return ArrayUtils.contains(VALID_LOCATION_ERR, this._locationErrCode);
  }

  /**
   * 取值跳转定位权限授权的设置页面want
   *
   * @returns 定位权限授权want
   */
  public getLocationSettingsWant(): Want | undefined {
    if (this._locationErrCode === LocationErrorCode.DEFAULT_CODE) {
      return undefined;
    }
    let isOff = this._locationErrCode === LocationErrorCode.LOCATION_SWITCH_OFF;
    let locationWant: Want = {
      bundleName: SettingsInfo.SETTINGS_BUNDLE_NAME,
      abilityName: SettingsInfo.SETTINGS_ABILITY_NAME,
      uri: isOff ? LocationPermission.LOCATION_MANAGER_URI : LocationPermission.APPLICATION_ENTRY_URI
    };
    let appBundleName = this._immWant?.bundleName;
    if (!isOff && appBundleName) {
      locationWant.parameters = { pushParams: appBundleName };
    }
    return locationWant;
  }

  /**
   * 无定位权限tip提示语
   *
   * @returns 无权限提示语
   */
  @Computed get locationNoPermissionTip(): ResourceStr {
    if (this._locationErrCode === LocationErrorCode.DEFAULT_CODE) {
      return '';
    }
    // 应用无权限
    if (this._locationErrCode === LocationErrorCode.NO_PERMISSION) {
      return $r('app.string.immersive_app_no_auth_tips');
    }
    // 系统无权限时，区分应用是否有权限
    let hasAppPermission = ImmersiveComHelper.hasLocationPermission(this._immWant?.bundleName);
    return hasAppPermission ? $r('app.string.immersive_sys_no_auth_tips') :
      $r('app.string.immersive_app_sys_no_auth_tips');
  }

  /**
   * 是否沉浸态常亮
   *
   * @returns true沉浸态常亮
   */
  public isKeepScreenOnEnable(): boolean {
    return this._isKeepScreenOnEnable && this.isOtherNavCard() ? true : false;
  }

  /**
   * UIExtension连接成功，设置loading状态
   *
   * @param proxy UIExtension代理信息
   */
  public setExtOnRemoteReady(proxy: UIExtensionProxy): void {
    this.setExtLoading(true);
    this.delayUpdateLoadingState();
  }

  /**
   * 创建定时器
   */
  private delayUpdateLoadingState(): void {
    this.clearLoadingState(false);
    this._loadingTimer = setTimeout(() => {
      this.clearLoadingState(true);
      this.setExtLoading(false)
    }, MAX_LOADING_TIME_MS);
  }

  /**
   * 清除UIExtension loading定时器
   *
   * @param hasTimeout 是否含有定时器函数
   */
  public clearLoadingState(hasTimeout: boolean): void {
    if (this._loadingTimer) {
      if (!hasTimeout) {
        clearTimeout(this._loadingTimer);
      }
      this._loadingTimer = undefined;
    }
  }

  /**
   * 设置UIExtension loading状态
   *
   * @param isLoading loading状态
   */
  public setExtLoading(isLoading: boolean): void {
    if (this._isExtLoading !== isLoading) {
      this._isExtLoading = isLoading;
    }
  }

  /**
   * 获取UIExtension loading状态
   *
   * @return loading状态
   */
  public isExtLoading(): boolean {
    return Boolean(this._isExtLoading);
  }
}