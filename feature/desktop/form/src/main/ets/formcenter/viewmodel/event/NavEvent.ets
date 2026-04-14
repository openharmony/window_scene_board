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

import { GlobalContext } from '@ohos/frameworkwrapper';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { AppItemInfo, CardItemInfo } from '@ohos/launchercommon';
import { FormCenterViewModel } from '../FormCenterViewModel';
import { NavDestinationBuilderInterface } from '../../interfaces/NavDestinationBuilderInterface';
import { FormCenterSplitEventInterface } from '../../interfaces/FormCenterSplitEventInterface';
import { NavDestinationFactory, NavDestinationParam } from '../factory/NavDestinationFactory';
import { FormHiSysEventUtil } from '../../../default/util/FormHiSysEventUtil';
import FormStyleConstants from '../../../default/common/constants/FormStyleConstants';

const TAG = 'NavEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class NavEvent implements FormCenterSplitEventInterface {
  protected startFormInfo: CardItemInfo = new CardItemInfo();
  protected formCenterPage: NavPathStack = new NavPathStack();
  protected appItemInfoList: AppItemInfo[] = FormCenterViewModel.getInstance().getAppList();

  public initData(startFormInfo: CardItemInfo, formCenterPage: NavPathStack): void {
    this.startFormInfo = startFormInfo;
    this.formCenterPage = formCenterPage;
  }

  public onAppear(): void {
    if (CheckEmptyUtils.isEmptyArr(this.appItemInfoList)) {
      log.showError('empty app list');
      return;
    }
    if (CheckEmptyUtils.checkStrIsEmpty(this.startFormInfo.bundleName)) {
      log.showWarn(`empty start form info`);
      this.pushPathByNameWithCache(this.appItemInfoList[0].bundleName);
      return;
    }
    this.pushPathByNameWithCache(this.startFormInfo.bundleName);
  }

  public getInitIndex(): number {
    let index: number = this.appItemInfoList.findIndex(item => item.bundleName === this.startFormInfo.bundleName);
    index = index > 0 ? index : 0;
    return index;
  }

  public onIndexChange(index: number): void {
    log.showWarn(`index change ${index}, ${this.appItemInfoList[index].bundleName}`);
    if (index < 0 || index >= this.appItemInfoList.length) {
      log.showError(`invalid index: ${index}`);
      return;
    }
    this.pushPathByNameWithCache(this.appItemInfoList[index].bundleName);
  }

  public getBuildInterface(param: NavDestinationParam): NavDestinationBuilderInterface {
    return NavDestinationFactory.createNavLayout(param);
  }

  public onListItemClick(event: ClickEvent, bundleName: string): void {
    // 打断一镜到底动效
    GlobalContext.getContext()?.eventHub.emit('interruptFormEffect');
    // 应用列表点击打点
    FormHiSysEventUtil.reportFormCenterClickAppList(bundleName);
  }

  public pushPathByName(name: string): void {
    if (CheckEmptyUtils.checkStrIsEmpty(name)) {
      log.showError(`invalid path name: ${name}`);
      return;
    }
    this.pushPathByNameWithCache(name);
  }

  // 防止卡片重复创建问题， 缓存已经打开过的列表中的卡片
  protected pushPathByNameWithCache(name: string): void {
    FormCenterViewModel.getInstance().isCurrentSuggestion = name === FormStyleConstants.FORM_CENTER_DEFAULT_ITEM;
    let namesInStack: string[] = this.formCenterPage.getAllPathName() ?? [];
    if (namesInStack.includes(name)) {
      this.formCenterPage.moveToTop(name, false);
      // 缓存的最大长度为10
      if (namesInStack.length > 10) {
        this.formCenterPage.removeByIndexes([0]);
      }
    } else {
      this.formCenterPage.pushPathByName(name, null, false);
    }
  }
}