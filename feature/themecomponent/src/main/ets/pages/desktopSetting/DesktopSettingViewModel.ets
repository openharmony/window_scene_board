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

import contextConstant from '@ohos.app.ability.contextConstant';
import common from '@ohos.app.ability.common';
import dataPreferences from '@ohos.data.preferences';
import fs from '@ohos.file.fs';
import { BusinessError } from '@kit.BasicServicesKit';
import { UIExtensionContentSession, Want } from '@kit.AbilityKit';
import { DesktopSettingData } from './DesktopSettingData';
import { IconEditPageUtils } from './IconEditPageUtils';
import { DesktopParam } from './DesktopParam';
import DeviceInfo from '@ohos.deviceInfo';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { Log } from '../../aigcServiceAbility/IdlService/Log';

const TAG = 'DesktopSettingViewModel';

export class DesktopSettingConstants {
  public static readonly AUTO_ALIGN_STATUS: string = 'autoAlignStatus';
  public static readonly LOCK_LAYOUT_STATUS: string = 'lockLayoutStatus';
  //从设置搜索进来的
  public static readonly UI_EXTENSION_SOURCE: string = 'settingSearch';
  public static readonly PREFERENCES_NAME: string = 'DesktopSetting';
  //控件默认值大小
  public static readonly TITLE_LEFT_DEFAULT: number = 8;
}

/*
  基于不同的场景组件参数（比如从搜索直接跳转）
 */
class DeskSettingPositionParam {
  private _fromSearch: boolean = false;

  public set fromSearch(value: boolean) {
    this._fromSearch = value;
  }

  public get fromSearch(): boolean {
    return this._fromSearch;
  }
}

/**
 * DesktopSetting页面的ViewModel
 */
export class DesktopSettingViewModel {
  private desktopSettingData: DesktopSettingData = new DesktopSettingData();
  private preference: dataPreferences.Preferences | undefined;
  // private static sInstance: Singleton<DesktopSettingViewModel> =
  //   new Singleton<DesktopSettingViewModel>(() => new DesktopSettingViewModel);
  private deskSetParam: DeskSettingPositionParam = new DeskSettingPositionParam();
  private static sInstance: ESObject;
  // private wantParams: WantParams | undefined;
  private wantParams: ESObject | undefined;
  private pageInfo: NavPathStack | undefined;
  public static getInstance(): DesktopSettingViewModel {
    return DesktopSettingViewModel.sInstance.get();
  }

  public getDesktopSettingData(): DesktopSettingData {
    return this.desktopSettingData;
  }

  public getDeskSetParam(): DeskSettingPositionParam {
    return this.deskSetParam;
  }

  public preferenceOffCallback(): void {
    if (this.preference) {
      this.preference.off('multiProcessChange', this.preferenceCallback);
    }
  }

  /*
     初始化页面
   */
  public initDesktopSettingData(pageInfos: NavPathStack): void {
    this.pageInfo = pageInfos;
    // let want: WantParams[] = pageInfos.getParamByName(Constants.DESKTOP_SETTING_PAGE) as WantParams[];
    let want: ESObject[] = pageInfos.getParamByName('')
    if (want && want.length > 0 && want[0]) {
      this.wantParams = want[0]
      if (this.wantParams.source === DesktopSettingConstants.UI_EXTENSION_SOURCE) {
        // 从设置搜索直接跳转的场景
        this.deskSetParam.fromSearch = true;
      }
    }
    try {
      let context = getContext().getApplicationContext();
      let oldArea = context.area;
      context.area = contextConstant.AreaMode.EL1;
      dataPreferences.removePreferencesFromCacheSync(context, DesktopSettingConstants.PREFERENCES_NAME);
      this.preference?.off('multiProcessChange', this.preferenceCallback);
      dataPreferences.getPreferences(context, DesktopSettingConstants.PREFERENCES_NAME)
        .then((preferences: dataPreferences.Preferences) => {
        this.preference = preferences;
        this.desktopSettingData.autoAlignStatus =
          this.preference.getSync(DesktopSettingConstants.AUTO_ALIGN_STATUS, false) as boolean;
        this.desktopSettingData.lockLayoutStatus =
          this.preference.getSync(DesktopSettingConstants.LOCK_LAYOUT_STATUS, false) as boolean;
        Log.warn(TAG, 'init %{public}s, preferencesDir: %{public}s',
          this.desktopSettingData.toString(), context.preferencesDir);
         this.preference.on('multiProcessChange', this.preferenceCallback);
        context.area = oldArea;
      });
    } catch (e) {
      Log.error(TAG, `Preference Error, ${(e as BusinessError).message}`);
    }
  }

  public preferenceCallback = (key: string): void => {
    Log.info(TAG, 'preferenceCallback key: %{public}s', key);
    if (this.pageInfo) {
      this.initDesktopSettingData(this.pageInfo);
    }
  }

  public onBackPressed(pageInfos: NavPathStack): boolean {
    let source: string = '';
    let session: UIExtensionContentSession | undefined = undefined;
    if (this.wantParams) {
      if (this.wantParams.source) {
        source = this.wantParams.source;
      }
      if (this.wantParams.session) {
        session = this.wantParams.session;
      }
    }
    //从搜索栏进入设置
    if (source === DesktopSettingConstants.UI_EXTENSION_SOURCE) {
      Log.info(TAG, 'onBackPressed send action pop');
      try {
        session?.sendData({ 'action': 'pop' })
      } catch (error) {
        Log.error(TAG, `registerCallBack error, ${error}`);
      }
    } else {
      Log.info(TAG, 'onBackPressed pop');
      pageInfos.pop(true);
    }
    return true;
  }

  /**
   * 保存Preference
   */
  public savePreference(key: string, value: boolean): void {
    if (!this.preference) {
      Log.warn(TAG, 'preference is undefined!');
      return;
    }
    try {
      if (key === DesktopSettingConstants.AUTO_ALIGN_STATUS && value === this.desktopSettingData.autoAlignStatus) {
        return;
      } else if (key === DesktopSettingConstants.LOCK_LAYOUT_STATUS &&
        value === this.desktopSettingData.lockLayoutStatus) {
        return;
      }
      this.preference.putSync(key, value);
      this.preference.flush(() => {
        if (key === DesktopSettingConstants.AUTO_ALIGN_STATUS) {
          this.desktopSettingData.autoAlignStatus = value;
        } else if (key === DesktopSettingConstants.LOCK_LAYOUT_STATUS) {
          this.desktopSettingData.lockLayoutStatus = value;
        }
        Log.warn(TAG, 'save savePreference[%{public}s] = %{public}s', key, this.desktopSettingData.toString());
      });
    } catch (e) {
      Log.error(TAG, `save savePreference Error, ${(e as BusinessError).message}`);
    }
  }

  /**
   * 跳转负一屏
   */
  public launchIntelligent(uiAbilityContext: common.UIAbilityContext): void {
    if (!uiAbilityContext) {
      Log.error(TAG, `startAbility return, context is empty`);
      return;
    }
    let parameters: Record<string, string> = {
      'page': 'settings',
      'from': 'deskTopSettings',
      'transId': new Date().getTime().toString(),
      'ohos.aafwk.param.callerBundleName': 'com.ohos.sceneboard'
    };
    let want: Want = {
      bundleName: 'com.ohos.intelligent',
      abilityName: 'MainAbility',
      moduleName: 'product',
      parameters: parameters
    }
    try {
      uiAbilityContext.startAbility(want).then(() => {
        Log.info(TAG, 'startAbility bundleName: %{public}s successful.', want.bundleName);
      }).catch((error : BusinessError) => {
        Log.error(TAG, 'startAbility bundleName: %{public}s failed. %{public}d %{public}s',
          want.bundleName, error.code, error.message);
      })
    } catch {
      Log.error(TAG, 'startAbility bundleName: %{public}s failed.', want.bundleName);
    }
  }

  private isPcMode(): boolean {
    if (!this.isSupportWindowPcModeSwitch()) {
      return false;
    }
    try {
      let res = systemParameterEnhance.getSync('persist.sceneboard.ispcmode', 'false');
      Log.info(TAG, 'isPcMode:' + res);
      return res === 'true';
    } catch (e) {
      Log.error(TAG, `Get pc mode switch failed`);
      return false;
    }
  }

  public isPC(): boolean {
    if (this.isSupportWindowPcModeSwitch()) {
      return this.isPcMode();
    }
    return DeviceInfo.deviceType === '2in1';
  }

  /**
   * 是否支持PAD/PC模式切换
   */
  private isSupportWindowPcModeSwitch(): boolean {
    try {
      let res = systemParameterEnhance.getSync('const.window.support_window_pcmode_switch', 'false');
      Log.info(TAG, 'isSupportWindowPcModeSwitch:' + res);
      return res === 'true';
    } catch (e) {
      Log.error(TAG, 'Get switch supportWindowPcModeSwitch failed');
      return false;
    }
  }

  /**
   * 获取桌面参数，供图标编辑页使用
   */
  private getDesktopParam(): void {
    // let hapName = DeviceHelper.isPad() ? 'pad_sceneboard' : 'phone_sceneboard';
    let hapName = 'phone_sceneboard';
    let previewPath = `/data/storage/el1/base/haps/${hapName}/files/desktopPreview/desktopParam.json`;
    try {
      if (fs.accessSync(previewPath)) {
        let desktopParamText = fs.readTextSync(previewPath);
        let firstChar: number = desktopParamText.indexOf('}');
        if ((firstChar + 1) !== desktopParamText.length) {
          desktopParamText = desktopParamText.slice(0, firstChar + 1);
        }
        let desktopParams: DesktopParam = new DesktopParam();
        if (!!desktopParamText) {
          desktopParams = JSON.parse(desktopParamText);
          Log.info(TAG, `get desktopParams success = ` + JSON.stringify(desktopParams));
          AppStorage.setOrCreate('desktopParam', desktopParams);
        }
      } else {
        Log.error(TAG, 'file not exist');
      }
    } catch (e) {
      Log.error(TAG, 'get desktopParams path error');
    }
  }

  private getIconEditPageWant(): Want {
    return {
      bundleName: 'com.ohos.sceneboard',
      abilityName: 'EditModeIconAbilityPhone',
      parameters: {
        'nav': 'icon',
        'ability.want.params.uiExtensionType': 'sys/commonUI',
        'desktopParam': AppStorage.get<Object>('desktopParam') as Object,
        'from': 'desktopSettings'
      }
    }
  }

  /**
   * 预加载图标编辑UIExtension
   * @returns
   */
  public preloadIconEditPage(): void {
    let want: Want = this.getIconEditPageWant();
    IconEditPageUtils.preloadIconEditPageExtAbility(getContext(), want.abilityName as string,
      want.parameters as Record<string, Object>);
  }

  /**
   * 点击图标调节按钮，拉起图标编辑页UIExtension
   * 由于通过搜索进入的桌面设置与直接进入的桌面设置ability不同，session不同
   * 故对不同场景需用使用不同的session来sendData
   */
  public doSendData(): void {
    let source: string = '';
    let session: UIExtensionContentSession | undefined = undefined;
    if (this.wantParams) {
      if (this.wantParams.source) {
        source = this.wantParams.source;
      }
      if (this.wantParams.session) {
        session = this.wantParams.session;
      }
    }
    try {
      DesktopSettingViewModel.getInstance().getDesktopParam();
      let want: Want = this.getIconEditPageWant();
      // 从设置搜索栏 or 全搜进入桌面设置
      if (source === DesktopSettingConstants.UI_EXTENSION_SOURCE) {
        session?.sendData({
          'iconEditPageWant': want,
        })
        Log.info(TAG, `open Icons page form settingSearch`);
      } else {
        // if (NavigationUtil.session) {
        //   NavigationUtil.session.sendData({
        //     'iconEditPageWant': want,
        //   });
          Log.info(TAG, `open Icons page`);
        // }
      }
    } catch (err) {
      Log.error(TAG, `send Msg error: ${err?.code}`);
    }
  }
}