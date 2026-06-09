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

import { systemDateTime } from '@kit.BasicServicesKit';
import fs from '@ohos.file.fs';
import { AigcConstant, PandoraVideoConfig, TaskConfig } from './AigcConstant';
import { Log } from './IdlService/Log';

/**
 * 单次加载文件支持最大的文件size大小
 */
const MAX_FILE_CONTENT_SIZE: number = 10 * 1024 * 1024;
const TAG = '[AigcService]AigcFileUtils';

export interface NodeObject {
  nodeName: string,
  attributes: Record<string, Object>,
  childNodes: NodeObject[]
}

export class AigcFileUtils {
  /**
   * 读取文件内容为string
   * @param filePath
   * @param maxFileSize
   * @returns
   */
  public static getStringByFile(filePath: string, maxFileSize: number = MAX_FILE_CONTENT_SIZE): string {
    if (!AigcFileUtils.isFileExists(filePath)) {
      return '';
    }
    try {
      const stat: fs.Stat = fs.statSync(filePath);
      if (stat.size > maxFileSize) {
        Log.warn(TAG, 'read target file too big');
        return '';
      }
      return fs.readTextSync(filePath);
    } catch (e) {
      Log.error(TAG, 'get file content fail');
      return '';
    }
  }

  /**
   * 判断文件是否存在
   * @param path
   * @returns
   */
  public static isFileExists(path: string | undefined): boolean {
    if (AigcFileUtils.isEmpty(path)) {
      return false;
    }
    let exist: boolean = false;
    try {
      exist = fs.accessSync(path);
    } catch (error) {
      Log.warn(TAG, `isFileExists error: ${error.message}`);
    }
    return exist;
  }

  /**
   * 判断字串是否为空
   * @param str
   * @returns
   */
  public static isEmpty(str: string | String | undefined): boolean {
    if (str === undefined || str === null) {
      return true;
    }
    if (typeof str === 'string' || str instanceof String) {
      return !str.trim();
    }
    return false;
  }

  /**
   * 以指定原始数据或文本创建文件
   * @param path 文件路径
   * @param contents 文本
   * @returns 此操作会替换原有位置的文件。
   */
  public static async createFileWithContents(path: string, contents:string): Promise<boolean> {
    let createdSuccessfully = true;
    try {
      let newPath: string = path;
      const fp: fs.File = await fs.open(newPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE | fs.OpenMode.TRUNC);
      try {
        await fs.write(fp.fd, contents);
      } catch (e) {
        Log.error(TAG, `createFileWithContents fs.write error:${e}`);
        createdSuccessfully = false;
      }
      await fs.close(fp);
    } catch (e) {
      Log.error(TAG, `createFileWithContents error:${e}`);
      createdSuccessfully = false;
    }
    return createdSuccessfully;
  }

  /**
   * 将指定对象序列化为 JSON 文本并创建文件
   * @param path 文件路径
   * @param jsonObject 待序列化的对象
   * @returns 是否成功
   * @desc 此操作会替换原有位置的文件。
   */
  public static async createFileWithJsonObject(path: string, jsonObject: object): Promise<boolean> {
    try {
      const jsonStr: string = JSON.stringify(jsonObject);
      return await AigcFileUtils.createFileWithContents(path, jsonStr);
    } catch (e) {
      Log.error(TAG, `createFileWithJsonObject error:${e}`);
      return false;
    }
  }

  /**
   * 拷贝目录，使两个目录路径下的内容相同
   * @param srcPath 源路径（必须存在）
   * @param destPath 目标路径（不存在则创建）
   * @returns 是否成功
   */
  public static copyDirectory(srcPath: string, destPath: string): boolean {
    try {
      const destExists: boolean = AigcFileUtils.isFileExists(destPath);
      if (!destExists) {
        // 如果目标目录不存在，则递归创建目标目录。
        fs.mkdirSync(destPath, true);
      }
      if (!srcPath.endsWith('/')) {
        srcPath += '/';
      }
      if (!destPath.endsWith('/')) {
        destPath += '/';
      }
      // copyDir 传入的源目录和目标目录都需要存在
      fs.copyDirSync(srcPath, destPath, 0);
      return true;
    } catch (e) {
      Log.error(TAG, `copyDirectoryRecursively error:${e}`);
      return false;
    }
  }

  public static editJsonScript(scriptPath: string, targetName: string, targetVal: string): void {
    Log.info(TAG, `editJsonScript targetName: ${targetName} targetVal: ${targetVal}`);
    if (!fs.accessSync(scriptPath)) {
      Log.error(TAG, 'scriptPath is not exist');
      return;
    }
    // const scriptContent: string = FileUtil.getStringByFile(scriptPath);
    // let scriptObject = JSON.parse(scriptContent) as NodeObject;
    // let result = AigcFileUtils.editJsonNodeRecursively(scriptObject, targetName, targetVal);
    // if (!result) {
      Log.error(TAG, 'targetName not found in the json file');
      // return;
    // }
    // FileUtil.createFileWithJsonObject(scriptPath, scriptObject);
  }

  public static editJsonNodeRecursively(rootNode: NodeObject, targetName: string, targetVal: string): boolean {
    if (rootNode.attributes.name === targetName) {
      rootNode.attributes.expression = targetVal;
      return true;
    }

    for (const childNode of rootNode.childNodes) {
      // 如果子节点找到目标，立即向上传递终止信号
      if (AigcFileUtils.editJsonNodeRecursively(childNode, targetName, targetVal)) {
        return true;
      }
    }
    return false;
  }

  public static getPandoraVideoConfig(configPath: string): PandoraVideoConfig | undefined {
    if (!AigcFileUtils.isFileExists(configPath)) {
      Log.error(TAG, 'getPandoraConfig fail, configDirPath not exists');
      return;
    }
    const configStr: string = AigcFileUtils.getStringByFile(configPath);
    if (configStr.length === 0) {
      Log.error(TAG, 'getPandoraConfig read config file fail');
      return;
    }
    let configJson: PandoraVideoConfig = new PandoraVideoConfig();
    try {
      configJson = JSON.parse(configStr) as PandoraVideoConfig;
    } catch (parseError) {
      Log.error(TAG, `getPandoraConfig JSON.parse Error: ${parseError?.code}, ${parseError?.message}`);
      return;
    }
    Log.info(TAG, 'getPandoraConfig success');
    return configJson;
  }

  /**
   * 删除文件夹下所有文件，保留文件夹
   * @param path 路径
   * @returns 是否成功
   */
  public static clearDirectory(path: string, suffix: string[] = []): boolean {
    try {
      if (fs.accessSync(path)) {
        fs.listFileSync(path, {filter: {suffix: suffix}}).forEach((fileName) => {
          let toUnlinkPath: string = `${path}/${fileName}`;
          fs.unlinkSync(toUnlinkPath);
          Log.info(TAG, `clearDirectory finish removeFile: ${fileName}`);
        })
        return true;
      } else {
        return false;
      }
    } catch (error) {
      Log.error(TAG, `clearDirectory Error: ${error?.code}, ${error?.message}`);
      return false;
    }
  }

  /**
   * 选取随机风格
   * @param type 性别/年龄 ['Female', 'Male', 'Girl' , 'Boy']
   * @param style 风格
   * @returns 选取的风格
   */
  public static randomStyle(type: string, style: string): string {
    let styleParam: string = '';
    if (style !== 'Random') {
      styleParam = style;
    } else {
      const styleList: string[] | undefined = AigcConstant.STYLE_MAP.get(type);
      if (styleList === undefined) {
        Log.error(TAG, `do not support this type ${type}`);
        return '';
      }
      styleParam = styleList[Math.floor(Math.random() * styleList.length)];
    }
    // return DeviceHelper.isFoldButNotSmallFoldProduct() ? `${styleParam}_fold` : styleParam;
    return ""
  }

  /**
   * 获取父文件夹路径
   * @param path 当前文件路径
   * @returns 父文件夹路径
   */
  public static getParentPath(path: string): string {
    // let index = path.lastIndexOf(Constants.FILE_SEPARATOR);
    // if (index >= 0) {
    //   return path.substring(0, index);
    // }
    return path;
  }

  /**
   * 获取文件夹下所有文件夹的路径
   * @param path 当前文件路径
   * @returns 父文件夹路径
   */
  public static listDirSync(path: string): string[] {
    try {
      let dirList: string[] = [];
      for (const dir of fs.listFileSync(path)) {
        const fullDir: string = `${path}/${dir}`;
        if (fs.lstatSync(fullDir).isDirectory()) {
          dirList.push(fullDir);
        }
      }
      return dirList.sort();
    } catch (error) {
      Log.error(TAG, `listDirSync failed: ${error?.code}, ${error?.message}`);
      return [];
    }
  }

  /**
   * 获取AIGC视频主题生成过的模板名称
   * @param videoThemeConfig AIGC视频主题配置
   * @returns 历史模板名称列表
   */
  public static parseExistingTemplate(templateList: string): string[] {
    let resultArray: string[] = [];
    let tabList: Set<string> = new Set<string>();
    try {
      let curMap: Record<string, Object> = JSON.parse(templateList) as Record<string, Object>;
      if (curMap) {
        Object.keys(curMap).forEach(key => {
          tabList.add(curMap[key].toString());
        });
      }
      resultArray = Array.from(tabList);
    } catch (error) {
      Log.error(TAG, `parse template list Error: ${error?.code}, ${error?.message}`);
    }
    return resultArray;
  }

  /**
   * 记录AIGC视频主题生成任务的状态
   * @param status 生成任务的状态
   * @param errorCode 任务的错误码
   * @param taskConfigPath 记录生成任务状态的路径
   * @returns 是否记录成功
   */
  public static async recordTaskConfig(status: ESObject, errorCode: number,
  // public static async recordTaskConfig(status: AIGCEditorStatus, errorCode: number,
    taskConfigPath: string): Promise<boolean> {
    let config: TaskConfig = {
      // beginTime: status === AIGCEditorStatus.FIRST_GENERATE_AI ? systemDateTime.getTime(false) : -1,
      beginTime: systemDateTime.getTime(false) ,
      status: status,
      errorCode: errorCode
    };
    return await AigcFileUtils.createFileWithJsonObject(taskConfigPath, config);
  }
}