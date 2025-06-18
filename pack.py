#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
FunnyBuff 插件打包脚本
过滤掉不需要的文件，只保留插件运行必需的文件，然后打包成zip文件
"""

import os
import zipfile
import shutil
from pathlib import Path
import datetime

def should_include_file(file_path, include_patterns, exclude_patterns):
    """
    判断文件是否应该被包含在打包中
    
    Args:
        file_path: 文件路径
        include_patterns: 包含模式列表
        exclude_patterns: 排除模式列表
    
    Returns:
        bool: 是否应该包含
    """
    file_path_str = str(file_path).lower()
    
    # 检查排除模式
    for pattern in exclude_patterns:
        if pattern in file_path_str:
            return False
    
    # 检查包含模式
    for pattern in include_patterns:
        if pattern in file_path_str:
            return True
    
    # 如果没有明确的包含模式，则包含所有未被排除的文件
    return True

def pack_addon():
    """
    打包插件的主要函数
    """
    # 定义包含和排除的文件模式
    include_patterns = [
        '.lua',
        '.toc',
        '.xml',
        '.tga',
        '.blp',
        '.mp3',
        '.ogg',
        '.wav'
    ]
    
    exclude_patterns = [
        '.git',
        'license',
        'readme',
        'pack.py',
        'test',
        '__pycache__',
        '.pyc',
        '.gitignore',
        '.gitmodules',
        'tests/',
        'test.lua',
        'test2.lua',
        'test3.lua',
        'test4.lua'
    ]
    
    # 获取当前目录
    current_dir = Path('.')
    addon_name = 'FunnyBuff'
    
    # 创建输出目录
    output_dir = Path('dist')
    output_dir.mkdir(exist_ok=True)
    
    # 生成zip文件名（包含时间戳）
    timestamp = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
    zip_filename = f'{addon_name}_{timestamp}.zip'
    zip_path = output_dir / zip_filename
    
    print(f'开始打包插件: {addon_name}')
    print(f'输出文件: {zip_path}')
    
    # 创建zip文件
    with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
        # 遍历所有文件
        for file_path in current_dir.rglob('*'):
            # 跳过目录
            if file_path.is_dir():
                continue
            
            # 跳过输出目录
            if 'dist' in str(file_path):
                continue
            
            # 判断是否应该包含此文件
            if should_include_file(file_path, include_patterns, exclude_patterns):
                # 计算相对路径（用于zip文件中的路径）
                relative_path = file_path.relative_to(current_dir)
                
                # 在zip文件内部直接使用FunnyBuff作为根文件夹
                zip_internal_path = f'{addon_name}/{relative_path}'
                
                # 添加到zip文件
                zipf.write(file_path, zip_internal_path)
                print(f'  + {zip_internal_path}')
            else:
                print(f'  - {file_path.relative_to(current_dir)} (已排除)')
    
    print(f'\n打包完成!')
    print(f'文件大小: {zip_path.stat().st_size / 1024:.2f} KB')
    print(f'文件位置: {zip_path.absolute()}')
    
    return zip_path

def clean_dist():
    """
    清理dist目录中的旧文件
    """
    dist_dir = Path('dist')
    if dist_dir.exists():
        print('清理旧的打包文件...')
        for file in dist_dir.glob('*.zip'):
            file.unlink()
            print(f'  删除: {file}')

if __name__ == '__main__':
    try:
        # 清理旧的打包文件
        clean_dist()
        
        # 执行打包
        zip_path = pack_addon()
        
        print('\n✅ 打包成功!')
        print(f'插件已打包到: {zip_path}')
        
    except Exception as e:
        print(f'❌ 打包失败: {e}')
        exit(1)

