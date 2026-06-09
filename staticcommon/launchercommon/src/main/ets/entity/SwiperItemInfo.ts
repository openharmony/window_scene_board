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

import FormSwiperColumns, { FormSwiperEnums } from '../db/column/FormSwiperColumns';
import type rdb from '@ohos.data.relationalStore';

/**
 * Item info of SwiperInfo item.
 */
export class SwiperItemInfo {
  /**
   * SwiperInfo: id 主键
   */
  public id: string | undefined;

  /**
   * SwiperInfo: info_name 元素名称
   */
  public infoName: string | undefined;

  /**
   * SwiperInfo: bundle_name 包名
   */
  public bundleName: string | undefined;

  /**
   * SwiperInfo: module_name 模块名
   */
  public moduleName: string | undefined;

  /**
   * SwiperInfo: ability_name Ability名称
   */
  public abilityName: string | undefined;

  /**
   * SwiperInfo: dimension 卡片尺寸
   */
  public dimension: number | undefined;

  /**
   * SwiperInfo: user_id 用户id
   */
  public userId: number | undefined;

  /**
   * convert from resultSet
   *
   * @param resultSet data from db
   * @returns SwiperItemInfo
   */
  public fromResultSet(resultSet: rdb.ResultSet): SwiperItemInfo {
    if (resultSet !== null) {
      this.id = String(resultSet.getLong(resultSet.getColumnIndex(FormSwiperColumns.ID)));
      this.infoName = resultSet.getString(resultSet.getColumnIndex(FormSwiperColumns.INFO_NAME));
      this.bundleName = resultSet.getString(resultSet.getColumnIndex(FormSwiperColumns.BUNDLE_NAME));
      this.moduleName = resultSet.getString(resultSet.getColumnIndex(FormSwiperColumns.MODULE_NAME));
      this.abilityName = resultSet.getString(resultSet.getColumnIndex(FormSwiperColumns.ABILITY_NAME));
      this.userId = resultSet.getLong(resultSet.getColumnIndex(FormSwiperColumns.USER_ID));
      this.dimension = resultSet.getLong(resultSet.getColumnIndex(FormSwiperColumns.DIMENSION));
    }
    return this;
  }

  /**
   * convert to valuesBucket
   *
   * @returns ValuesBucket
   */
  public toValuesBucket(): rdb.ValuesBucket {
    return {
      [FormSwiperEnums.ID]: this.id,
      [FormSwiperEnums.INFO_NAME]: this.infoName,
      [FormSwiperEnums.BUNDLE_NAME]: this.bundleName,
      [FormSwiperEnums.ABILITY_NAME]: this.abilityName,
      [FormSwiperEnums.MODULE_NAME]: this.moduleName,
      [FormSwiperEnums.USER_ID]: this.userId,
      [FormSwiperEnums.DIMENSION]: this.dimension
    };
  }
}
