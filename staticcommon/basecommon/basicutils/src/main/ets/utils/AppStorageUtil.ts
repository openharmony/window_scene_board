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
import { DomainName, LogDomain, LogHelper } from './LogHelper';
import { Trace } from './Trace';
import { TraceUtil } from './TraceUtil';
import systemparameter from '@ohos.systemparameter';
import { CheckEmptyUtils } from './CheckEmptyUtils';

/**
 * 存放在AppStorage中的数据属性
 */
export class DataProperty {
  // 是否和UI相关
  public isUI: boolean;
  // 是否可异步
  public isAsync: boolean;
  // 数据类型：string, number, boolean等
  public dataType?: string;

  constructor(isUI: boolean, isAsync: boolean, dataType?: string) {
    this.isUI = isUI;
    this.isAsync = isAsync;
    this.dataType = dataType;
  }

  /**
   * 获取数据信息
   *
   * @param dataProperty 数据属性
   * @returns
   */
  public static toString(dataProperty: DataProperty): string {
    return `dataType: ${dataProperty.dataType}, isUI: ${dataProperty.isUI}, isAsync: ${dataProperty.isAsync}`;
  }
}

const TAG = 'AppStorageUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 封装AppStorage相关接口，提供
 */
export class AppStorageUtil {
  // 打印数据属性和记录trace开关，默认关闭
  private static sIsPrintLog: boolean = systemparameter.getSync('print.data.property.enable', 'false') === 'true';

  /**
   * 封装AppStorage.setOrCreate
   *
   * @param propName key
   * @param newValue value
   * @param dataProperty 数据属性
   */
  public static setOrCreate<T>(propName: string, newValue: T | undefined, dataProperty?: DataProperty): void {
    if (AppStorageUtil.sIsPrintLog) {
      if (!CheckEmptyUtils.isEmpty(dataProperty)) {
        if (dataProperty && !dataProperty?.dataType) {
          dataProperty.dataType = typeof newValue;
        }
        log.showInfo('propName: ' + propName + ' -> ' + DataProperty.toString(dataProperty) + ' , dataLen: ' +
        JSON.stringify(newValue).length);
      }
      TraceUtil.startTrace(DomainName.SCB, Trace.CORE_METHOD_APP_STORAGE_SET + '_' + propName);
    }
    AppStorage.setOrCreate(propName, newValue);
    if (AppStorageUtil.sIsPrintLog) {
      TraceUtil.endTrace(DomainName.SCB, Trace.CORE_METHOD_APP_STORAGE_SET + '_' + propName);
    }
  }

  /**
   * 是否打印日志
   *
   * @param isPrintLog 打印日志开关
   */
  public static setPrintLog(isPrintLog: boolean): void {
    AppStorageUtil.sIsPrintLog = isPrintLog;
  }
}