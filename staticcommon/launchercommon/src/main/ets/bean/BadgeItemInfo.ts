/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { BadgeColumns } from '@ohos/frameworkwrapper';
import type rdb from '@ohos.data.relationalStore';
import { CommonConstants } from '../constants/CommonConstants';
import { BaseBundleInfo } from './BaseBundleInfo';
import { CheckEmptyUtils } from '@ohos/basicutils/src/main/ets/TsIndex';

/**
 * Item info of BadgeInfo item.
 */
export default class BadgeItemInfo implements BaseBundleInfo {
  /**
   * id
   */
  public id: number | undefined;

  /**
   * application bundle name
   */
  public bundleName: string = '';

  /**
   * badge number in app
   */
  public badgeNumber: number | undefined;

  /**
   * badge display flag
   */
  public isShow: boolean | undefined;

  /**
   * belong user
   */
  public userId: number | undefined;

  /**
   * app clone index
   */
  public appIndex: number | undefined;

  /**
   * badge update task
   */
  public badgeUpdateTaskStatus: boolean | undefined;

  /**
   * app appInstanceKey
   */
  public appInstanceKey?: string;

  /**
   * badge fixed
   */
  public fixed?: number;

  /**
   * convert from resultSet
   *
   * @param resultSet data from db
   * @returns BadgeItemInfo
   */
  public fromResultSet(resultSet: rdb.ResultSet): BadgeItemInfo {
    if (resultSet != null) {
      this.id = resultSet.getLong(resultSet.getColumnIndex(BadgeColumns.ID));
      this.bundleName = resultSet.getString(resultSet.getColumnIndex(BadgeColumns.BUNDLE_NAME));
      this.badgeNumber = resultSet.getLong(resultSet.getColumnIndex(BadgeColumns.BADGE_NUMBER));
      this.isShow = resultSet.getLong(resultSet.getColumnIndex(BadgeColumns.IS_SHOW)) === CommonConstants.BADGE_DISPLAY_SHOW;
      this.userId = resultSet.getLong(resultSet.getColumnIndex(BadgeColumns.USER_ID));
      this.appIndex = resultSet.getLong(resultSet.getColumnIndex(BadgeColumns.APP_INDEX));
      this.fixed = resultSet.getLong(resultSet.getColumnIndex(BadgeColumns.FIXED));
    }
    return this;
  }

  /**
   * check appInstanceKey, empty return false,Non-empty return true
   *
   * @parm appInstanceKey
   * @returns boolean
   * */
  public checkAppInstanceKey(appInstanceKey?: string): boolean {
    if (CheckEmptyUtils.checkStrIsEmpty(appInstanceKey)) {
      return false;
    }
    return true;
  }
}
