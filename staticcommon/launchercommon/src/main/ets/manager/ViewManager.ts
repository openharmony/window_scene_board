/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import systemParameter from '@ohos.systemParameterEnhance';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { launcherStatusUtil } from '@ohos/windowscene';
import { AppItemInfo } from '../bean/AppItemInfo';
import { CommonConstants } from '../constants/CommonConstants';
import { FormCenterViewManager, FormCenterViewParam } from './FormCenterViewManager';
import type { CardItemInfo } from '../bean/CardItemInfo';
import { FolderManager, FormEditViewManager, FormModel, GridLayoutItemInfo } from '../TsIndex';
import { FormEditViewParam } from './FormEditViewManager';

const TAG = 'ViewManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 界面管理类：用于跳转界面.
 */
export class ViewManager {
  private static sInstance: ViewManager;

  private constructor() {
  }

  /**
   * 获取单实例
   *
   * @returns 实例
   */
  public static getInstance(): ViewManager {
    if (ViewManager.sInstance == null) {
      ViewManager.sInstance = new ViewManager();
    }
    return ViewManager.sInstance;
  }

  /**
   * 跳转到卡片管理界面
   *
   * @param formInfo 卡片信息
   * @param formManagerShowFrom 来源
   */
  public jumpToFormManagerView(formInfo: AppItemInfo | GridLayoutItemInfo, formManagerShowFrom: number): void {
    let param: FormCenterViewParam = new FormCenterViewParam();
    param.bundleName = formInfo.bundleName;
    param.formInfo = formInfo as CardItemInfo;
    let formCenterViewManager: FormCenterViewManager = FormCenterViewManager.getInstance();
    formCenterViewManager.setOpenAddFormViewSource(formManagerShowFrom);
    if (DeviceHelper.isPC()) {
      param.entrancePosition = formCenterViewManager.getEntrancePos(formInfo);
      formCenterViewManager.openFormCenterView(param);
      return;
    }

    param.viewHeight = 0;
    if (FormModel.getInstance().isSupportFormCenterSplit()) {
      this.intoFormManagerView(formInfo, param, true);
    } else {
      // 菜单点击卡片场景，延时拉起卡片管理，降低首帧负载，提升响应时延
      let timer: number = setTimeout(() => {
        this.intoFormManagerView(formInfo, param, false);
        clearTimeout(timer);
      }, 10);
    }
  }

  private intoFormManagerView(formInfo: AppItemInfo | GridLayoutItemInfo, param: FormCenterViewParam,
    isSplit?: boolean): void {
    let formCenterViewManager: FormCenterViewManager = FormCenterViewManager.getInstance();
    if (isSplit) {
      formCenterViewManager.openFormCenterView(param);
    } else {
      formCenterViewManager.openFormManagerView(param);
    }
    AppStorage.setOrCreate('manageFormItem', formInfo);
    AppStorage.setOrCreate('enterFormManager', true);
  }

  /**
   * 退出编辑模式
   */
  public exitEditMode(): void {
    if (AppStorage.get('isEditMode')) {
      AppStorage.setOrCreate('exitEditModeAndBackDeskTopFlag', true);
    }
  }

  /**
   * 打开'服务卡片'界面
   *
   * @param formServiceShowFrom 从哪里打开的
   */
  public jumpFormServiceView(formServiceShowFrom: number): void {
    let formCenterViewManager: FormCenterViewManager = FormCenterViewManager.getInstance();
    formCenterViewManager.setOpenAddFormViewSource(formServiceShowFrom);
    formCenterViewManager.openFormCenterView();
  }

  /**
   * 关闭'卡片中心及卡片管理'界面
   */
  public closeFormServiceAndManagerView(): void {
    let formCenterViewManager: FormCenterViewManager = FormCenterViewManager.getInstance();
    if (formCenterViewManager.isFormManagerViewShowing()) {
      formCenterViewManager.closeFormManagerView();
    }
    if (formCenterViewManager.isFormCenterViewShowing()) {
      formCenterViewManager.closeFormCenterView();
    }
  }

  /**
   * 判断桌面是否需要处理手势事件
   */
  public isDesktopNeedProcessGesture(): boolean {
    const isFolderOpen: boolean = FolderManager.getInstance().isFolderOpen();
    if (isFolderOpen ||
      FormCenterViewManager.getInstance().isFormManagerViewShowing() ||
      FormCenterViewManager.getInstance().isFormCenterViewShowing() ||
      AppStorage.get('formStackEditShow') ||
      this.outerMenuCloseByGesture() ||
      launcherStatusUtil.getDesktopAddModeStatus()) {
      return true;
    }
    return false;
  }

  public closeFormStackEditView(): void {
    AppStorage.setOrCreate('formStackEditShow', false);
  }

  /**
   * 监听手势关闭菜单
   */
  public closeOuterStackMenu(): void {
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      AppStorage.setOrCreate('outerStackMenuNeedProcessGesture', false);
      AppStorage.setOrCreate('outerCardMenuNeedProcessGesture', false);
    }
  }

  private outerMenuCloseByGesture(): boolean {
    return (launcherStatusUtil.getShowOutLauncherStatus() && (AppStorage.get('outerStackMenuNeedProcessGesture') ||
      AppStorage.get('outerCardMenuNeedProcessGesture'))) ?? false;
  }

  /**
   * 大文件夹退场-home手势与back手势
   */
  public closeOpenFolderStatus(): void {
    log.showInfo(`closeOpenFolderStatus ${AppStorage.get('folderAppListDialogStatus')}`);
    if (AppStorage.get('folderAppListDialogStatus')) {
      AppStorage.setOrCreate('folderAppListDialogStatus', false);
      return;
    }
    if (FormCenterViewManager.getInstance().isFormCenterViewShowing() ||
      FormCenterViewManager.getInstance().isFormManagerViewShowing()) {
      return;
    }
    const isFolderOpen: boolean = FolderManager.getInstance().isFolderOpen();
    if (isFolderOpen) {
      log.showInfo('to closeOpenFolderStatus');
      AppStorage.setOrCreate('openFolderStatus', CommonConstants.FOLDER_STATUS_REQUEST_CLOSE);
    }
  }

  /**
   * 跳转到卡片统一编辑页
   *
   * @param formInfo 卡片信息
   */
  public jumpToFormEditView(formInfo: AppItemInfo, formEditShowFrom: number): void {
    let param: FormEditViewParam = new FormEditViewParam();
    param.bundleName = formInfo.bundleName;
    param.formInfo = formInfo as CardItemInfo;
    let formEditViewManager: FormEditViewManager = FormEditViewManager.getInstance();
    FormCenterViewManager.getInstance().setOpenAddFormViewSource(formEditShowFrom);

    formEditViewManager.setEditingFormInfo(param.formInfo);
    // 卡片编辑半模态窗口 和 其它半模态窗口统一管理，非半模态窗（自由窗口）则直接拉起
    if (!formEditViewManager.isSheetEditView) {
      formEditViewManager.openFormEditView(param);
    }
    AppStorage.setOrCreate('manageFormItem', formInfo);
    AppStorage.setOrCreate('enterFormEdit', true);
  }
}