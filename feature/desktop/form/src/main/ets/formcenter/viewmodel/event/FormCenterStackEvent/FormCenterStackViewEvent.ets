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

import { GlobalContext } from '@ohos/frameworkwrapper';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  AppItemInfo,
  CommonConstants,
  FormCenterViewManager,
} from '@ohos/launchercommon';
import {
  FormCenterViewParam,
  FormDisplayType,
  FormCenterLocation
} from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { FormCenterStackViewInterface } from '../../../interfaces/FormCenterStackViewInterface';
import { FormCenterViewModel } from '../../FormCenterViewModel';
import { FormCenterResponseCode } from '../../../../default/service/ServiceInterface';
import { SearchComponentParam } from '../../../view/atomicview/SearchComponent';
import { FormHiSysEventUtil } from '../../../../default/util/FormHiSysEventUtil';
import FormStyleConstants from '../../../../default/common/constants/FormStyleConstants';

const TAG = 'FormCenterStackViewEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormCenterStackViewEvent implements FormCenterStackViewInterface {
  protected openHighIndexView: boolean = false;
  protected appList: AppItemInfo[] = [];

  constructor(openHighIndexView: boolean, appList: AppItemInfo[]) {
    this.openHighIndexView = openHighIndexView;
    this.appList = appList;
  }

  public onListItemClick(item: AppItemInfo): void {
    if (CheckEmptyUtils.checkStrIsEmpty(item.bundleName)) {
      log.showError('bundleName is empty');
      return;
    }
    let isScreenLockFormDrag: boolean | undefined = AppStorage.get<boolean>('isScreenLockFormDrag');
    if (isScreenLockFormDrag) {
      log.showInfo('screenLock card is drag');
      return;
    }
    FormCenterViewManager.getInstance().hideFormCenterView(FormStyleConstants.FORM_MANAGER_VIEW_HEIGHT);
    let bundleName: string = item.bundleName;
    // 应用列表点击打点
    FormHiSysEventUtil.reportFormCenterClickAppList(bundleName);

    let param: FormCenterViewParam = this.getFormCenterViewParam(bundleName);
    FormCenterViewManager.getInstance().setOpenAddFormViewSource(
      CommonConstants.FORM_MANAGER_SHOW_FROM_FORM_SERVICE_FORM_APP);
    if (FormCenterViewModel.getInstance().isNegativeScreenOpen) {
      FormCenterViewManager.getInstance().openFormManagerViewByNegativeScreen(param);
    } else {
      FormCenterViewManager.getInstance().openFormManagerView(param);
    }
    GlobalContext.getContext()?.eventHub
      .emit('waitFormCenterResponse', { code: FormCenterResponseCode.JUMP_TO_FORM_MANAGER });
  }

  public getSearchComponentParam(): SearchComponentParam {
    let param: SearchComponentParam = new SearchComponentParam();
    param.fullAppList = this.appList;
    return param;
  }

  protected getFormCenterViewParam(bundleName: string): FormCenterViewParam {
    let param: FormCenterViewParam = new FormCenterViewParam();
    log.showWarn('click app item: ' + bundleName);
    param.bundleName = bundleName;
    param.openHighIndexView = this.openHighIndexView;
    param.isSupportDrag = FormCenterViewModel.getInstance().getIsSupportDrag();
    param.isSupportCreateAnimate = FormCenterViewModel.getInstance().getIsSupportCreateAnimate();
    param.formDisplayType = FormDisplayType.DESKTOP_CARD;
    param.location = FormCenterLocation.SCENE_PANEL;
    return param;
  }
}
